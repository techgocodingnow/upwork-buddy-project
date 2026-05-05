import Foundation

/// Upwork GraphQL query strings.
enum Queries {
    /// Current user's accounting entity ID — required as `aceIds_any` for
    /// `transactionHistory`. Freelancer-perspective ledger key.
    static let accountingEntity = """
    query AccountingEntity {
      accountingEntity {
        id
      }
    }
    """

    /// Freelancer-side ledger. Rows include earnings + fee adjustments.
    /// - `type`: `APInvoice` (earnings) | `APAdjustment` (fees, VAT, WHT, Service Fee)
    /// - `accountingSubtype`: `Hourly`, `Bonus`, `Service Fee`, `VAT`, `WHT`, ...
    /// - `transactionAmount`: `Money { rawValue: String, currency, displayValue }`
    /// - `assignmentCompanyName` is the client name; `assignmentTeamId` may be null.
    static let transactionHistory = """
    query TransactionHistory($filter: TransactionHistoryFilter!) {
      transactionHistory(transactionHistoryFilter: $filter) {
        transactionDetail {
          transactionHistoryRow {
            transactionCreationDate
            type
            accountingSubtype
            assignmentDeveloperName
            assignmentCompanyName
            assignmentTeamId
            transactionAmount {
              rawValue
              currency
            }
          }
        }
      }
    }
    """

    /// Freelancer-side hours + per-contract breakdown via `user.contractTimeReport`.
    /// `timeReportDate_bt` takes compact `YYYYMMDD` strings (NOT ISO8601). Input
    /// type name varies by tenant; literals are inlined to avoid that lookup.
    /// Returns gross `totalCharges` (hours × rate, before fees), real `totalHoursWorked`,
    /// and contract metadata including `hourlyTerms[].hourlyRate.rawValue`.
    static func contractTimeReport(rangeStart: String, rangeEnd: String) -> String {
        """
        query ContractTimeReport {
          user {
            contractTimeReport(
              timeReportDate_bt: {rangeStart: "\(rangeStart)", rangeEnd: "\(rangeEnd)"}
            ) {
              edges {
                node {
                  dateWorkedOn
                  weekWorkedOn
                  totalHoursWorked
                  totalCharges
                  contract {
                    id
                    title
                    status
                    clientTeam { name }
                    terms {
                      hourlyTerms {
                        hourlyRate { rawValue currency }
                      }
                    }
                  }
                }
              }
              pageInfo { endCursor hasNextPage }
            }
          }
        }
        """
    }

    /// `__schema` introspection slice — used by Introspection.swift in DEBUG builds.
    static let introspectType = """
    query IntrospectType($name: String!) {
      __type(name: $name) {
        name
        kind
        fields {
          name
          type {
            name
            kind
            ofType { name kind }
          }
        }
      }
    }
    """
}

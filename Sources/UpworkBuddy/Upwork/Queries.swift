import Foundation

/// Upwork GraphQL query strings.
///
/// Field names for `companySelector` and `contractTimeReport` are documented; the
/// `activeContracts` query uses a community-observed shape and should be re-confirmed
/// via `Scripts/introspect-schema.sh` against your tenant before relying on it.
enum Queries {
    static let companySelector = """
    query CompanySelector {
      companySelector {
        items {
          title
          organizationId
        }
      }
    }
    """

    /// Returns one row per (contract, day) within `[rangeStart, rangeEnd]`.
    /// Schema notes (verified via introspection 2026-05):
    /// - `totalCharges` is a scalar `Float`, not an object.
    /// - `ContractDetails` has no `hourlyChargeRate`; derive rate from earnings/hours.
    static let contractTimeReport = """
    query ContractTimeReport($filter: TimeReportFilter!) {
      contractTimeReport(filter: $filter) {
        edges {
          node {
            dateWorkedOn
            totalHoursWorked
            totalCharges
            contract {
              id
              title
            }
          }
        }
      }
    }
    """

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

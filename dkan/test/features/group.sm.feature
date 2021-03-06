# time:1m27.37s
@api @disablecaptcha @smoketest
Feature: Site managers administer groups

  Background:
    Given pages:
      | name      | url             |
      | Groups    | /groups         |
      | Content   | /admin/content/ |
    Given users:
      | name    | mail                | roles        |
      | John    | john@example.com    | site manager |
      | Gabriel | gabriel@example.com | editor       |
      | Jaz     | jaz@example.com     | editor       |
      | Katie   | katie@example.com   | editor       |
    Given groups:
      | title    | author | published |
      | Group 01 | John   | Yes       |
      | Group 02 | John   | Yes       |
      | Group 03 | John   | No        |
    And group memberships:
      | user    | group    | role on group        | membership status |
      | Gabriel | Group 01 | administrator member | Active            |
      | Katie   | Group 01 | member               | Active            |
      | Jaz     | Group 01 | member               | Pending           |

  @group_sm_01 @javascript @fixme
  Scenario: Create group
    Given I am logged in as "John"
    And I am on "Groups" page
    And I follow "Add Group"
    And I fill in "Title" with "My group"
    And I fill in "Description" with "This is a body"
    And I press "Save"
    Then I should see the success message "Group My group has been created"
    And I should see the heading "My group"
    And I should see "This is a body"
    And I should see the "img" element in the "group block" region

  @group_sm_02
  Scenario: Create group with previous same title
    Given I am logged in as "John"
    And I am on "Groups" page
    And I follow "Add Group"
    When I fill in the following:
      | Title       | Group 01       |
      | Description | This is a body |
    And I press "Save"
    Then I should see "A group with title Group 01 exists on the site. Please use another title."

  @group_sm_03
  Scenario: Add a group member on any group
    Given I am logged in as "John"
    And I am on "Group 02" page
    And I click "Group"
    And I click "Add people"
    And I fill in "Katie" for "User name"
    And I press "Add users"
    Then I should see "Katie has been added to the group Group 02"
    When I am on "Group 02" page
    And I click "Group"
    And I click "People"
    Then I should see "Katie"

  @group_sm_04
  Scenario: Remove a group member from any group
    Given I am logged in as "John"
    And I am on "Group 01" page
    And I click "Group"
    And I click "People"
    When I click "remove" in the "Katie" row
    And I press "Remove"
    Then I should see "The membership was removed"
    And I am on "Group 01" page
    And I click "Group"
    And I click "People"
    And I should not see "Katie"

  @group_sm_05
  Scenario: Delete any group
    Given I am logged in as "John"
    And I am on "Group 02" page
    When I click "Edit"
    Then I should see the button "Delete"
    When I press "Delete"
    Then I should see "Are you sure you want to delete"
    When I press "Delete"
    Then I should see "Group Group 02 has been deleted"

  @group_sm_06
  Scenario: Edit any group
    Given I am logged in as "John"
    And I am on "Group 02" page
    When I click "Edit"
    And I fill in "Description" with "Group 02 edited"
    And I press "Save"
    Then I should see "Group Group 02 has been updated"
    And I should be on the "Group 02" page

  @group_sm_07
  Scenario: Edit membership status of group member on any group
    Given I am logged in as "John"
    And I am on "Group 01" page
    And I click "Group"
    And I click "People"
    And I click "edit" in the "Katie" row
    When I select "Blocked" from "Status"
    And I press "Update membership"
    Then I should see "The membership has been updated"

  @group_sm_08
  Scenario: Edit group roles of group member on any group
    Given I am logged in as "John"
    And I am on "Group 01" page
    And I click "Group"
    And I click "People"
    And I click "edit" in the "Katie" row
    When I check "administrator member"
    And I press "Update membership"
    Then I should see "The membership has been updated"

  @group_sm_09
  Scenario: View permissions of any group
    Given I am logged in as "John"
    And I am on "Group 01" page
    And I click "Group"
    When I click "Permissions (read-only)"
    Then I should see the list of permissions for the group

  @group_sm_10
  Scenario: View group roles of any group
    Given I am logged in as "John"
    And I am on "Group 01" page
    And I click "Group"
    When I click "Roles (read-only)"
    Then I should see the list of roles for the group "Group 01"

  @group_sm_11
  Scenario Outline: View group role permissions of any group
    Given I am logged in as "John"
    And I am on "Group 01" page
    And I click "Group"
    And I click "Permissions (read-only)"
    Then I should see the list of permissions for "<role name>" role

    Examples:
      | role name            |
      | non-member           |
      | member               |
      | administrator member |

  @group_sm_12
  Scenario: View the number of members on any group
    Given I am logged in as "John"
    And I am on "Group 01" page
    And I click "Group"
    When I click "People"
    Then I should see "Total members: 4"

  @group_sm_13
  Scenario: View the number of content on any group
    Given datasets:
      | title      | publisher | author  | published | description                |
      | Dataset 01 | Group 01  | Katie   | Yes       | Increase of toy prices     |
      | Dataset 02 | Group 01  | Katie   | No        | Cost of oil in January     |
      | Dataset 03 | Group 01  | Gabriel | Yes       | Election results           |
    And I am logged in as "John"
    And I am on "Group 01" page
    And I click "Group"
    When I click "People"
    Then I should see "Total content: 3"

  @group_sm_14
  Scenario: View list of unpublished groups
    Given I am logged in as "John"
    And I am on "Content" page
    When I select "No" from "status"
    And I select "group" from "type"
    And I press "Apply"
    Then I should see "Group 03"


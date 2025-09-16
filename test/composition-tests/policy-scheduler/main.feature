# Copyright 2023 Swisscom (Schweiz) AG

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

@PolicyScheduler
Feature: Policy scheduler composition
  Tests the policy scheduler composition

  Background:
    Given input claim xr.yaml
    # following step is optional: default input composition is composition.yaml
    And input composition composition.yaml
    # following step is optional: default input functions is functions.yaml
    And input functions functions.yaml
    Then check that no resources are provisioning

  @normal
  Scenario: render composition and verify generated resources for schedules
    # render 1
    When crossplane renders the composition
    Then check that 6 resources are provisioning and they are
      | resource-name                     |
      | role-app-1                        |
      | role-app-2                        |
      | role-app-1-attach-0               |
      | role-app-1-detach-0               |
      | role-app-2-attach-1               |
      | role-app-2-detach-1               |
    # verify that one of the CronOperation schedules match the input times
    Then check that resource role-app-1-attach-0 has parameters
      | schedule | "2023-01-01T00:00:00Z" |
    Then check that resource role-app-1-detach-0 has parameters
      | schedule | "2023-12-31T23:59:59Z" |

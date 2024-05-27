/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  additive      = var.mode == "additive"

  # When there is only one entity, consider that the entity passed
  # might be dynamic. In this case the `for_each` will not use
  # entity name when constructing the unique ID.
  #
  # Other rules regrading the dynamic nature of resources:
  # 1. The roles might never be dynamic.
  # 2. Members might only be dynamic in `authoritative` mode.
  singular = length(var.entities) == 1

  # In singular mode, replace entity name with a constant "default". This
  # will prevent the potentially dynamic resource name usage in the `for_each`
  aliased_entities = local.singular ? ["default"] : var.entities

  # Values in the map need to be the proper entity names
  real_entities = var.entities

  bindings_by_conditions = distinct(flatten([
    for name in local.real_entities
    : [
      for binding in var.conditional_bindings
      : { name = name, role = binding.role, members = binding.members, condition = { expression = binding.expression } }
    ]
  ]))
}
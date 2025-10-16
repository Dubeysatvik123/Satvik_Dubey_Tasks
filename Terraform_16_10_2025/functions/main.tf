terraform {
  required_version = ">= 1.5.0"
}

#string_functions
output "str_upper"        { value = upper("satvik") }
output "str_lower"        { value = lower("SATVIK") }
output "str_title"        { value = title("mr satvik verma") }
output "str_trimspace"    { value = trimspace("  hello world  ") }
output "str_chomp"        { value = chomp("Satvik\n") }
output "str_format"       { value = format("user-%03d", 7) }
output "str_formatlist"   { value = formatlist("Hello %s!", ["Riya", "Karan", "Amit"]) }
output "str_join"         { value = join(" | ", ["Dev", "Sec", "Ops"]) }
output "str_replace"      { value = replace("Satvik uses Terraform", "Terraform", "Vault") }
output "str_substr"       { value = substr("TerraformLearning", 0, 9) }
output "str_trimprefix"   { value = trimprefix("dev-satvik", "dev-") }
output "str_trimsuffix"   { value = trimsuffix("report.txt", ".txt") }
output "str_reverse"      { value = join("", reverse(split("", "Satvik"))) }
output "str_regex"        { value = regex("Sat", "Satvik") }
output "str_startswith"   { value = startswith("Terraform", "Ter") }
output "str_endswith"     { value = endswith("cloud.tf", ".tf") }
output "str_contains"     { value = contains(split(" ", "Satvik Verma uses Terraform"), "Terraform") }

#numeric_functions
output "num_abs"          { value = abs(-42) }
output "num_ceil"         { value = ceil(3.14) }
output "num_floor"        { value = floor(7.9) }
output "num_max"          { value = max(5, 12, 9) }
output "num_min"          { value = min(5, 12, 9) }
output "num_signum"       { value = signum(-25) }



#type_conversion_functions
output "conv_tostring"    { value = tostring(123) }
output "conv_tonumber"    { value = tonumber("42") }
output "conv_tobool"      { value = tobool("true") }
output "conv_tomap"       { value = tomap({city = "Delhi"}) }
output "conv_tolist"      { value = tolist(["Karan", "Amit"]) }

#time_stamp_function
output "time_now"         { value = timestamp() }
output "time_add"         { value = timeadd("2025-10-16T00:00:00Z", "72h") }
output "time_formatdate"  { value = formatdate("YYYY-MM-DD", timestamp()) }

#network_functions
output "net_cidrhost"     { value = cidrhost("10.0.1.0/24", 5) }
output "net_cidrsubnet"   { value = cidrsubnet("10.0.0.0/16", 8, 3) }
output "net_cidrsplit"    { value = cidrsubnets("10.1.0.0/16", 4, 4) }

#file_system_functions
locals {
  file_path = "${path.module}/main.tf"
}
output "fs_abspath"       { value = abspath(path.module) }
output "fs_dirname"       { value = dirname(local.file_path) }
output "fs_basename"      { value = basename(local.file_path) }
output "fs_fileexists"    { value = fileexists(local.file_path) }
output "fs_file"          { value = substr(file(local.file_path), 0, 60) } # Only preview

#encoding_decoding_functions
output "enc_jsonencode"   { value = jsonencode({name = "Satvik", role = "DevSecOps"}) }
output "enc_jsondecode"   { value = jsondecode("{\"name\":\"Riya\",\"role\":\"Tester\"}") }
output "enc_b64encode"    { value = base64encode("TerraformRocks") }
output "enc_b64decode"    { value = base64decode(base64encode("TerraformRocks")) }
output "enc_uuid"         { value = uuid() }

#collection_functions
output "dyn_try"          { value = try(element([], 0), "Fallback value") }
output "dyn_coalesce"     { value = coalesce("", "first_non_empty", "last") }
output "dyn_coalescelist" { value = coalescelist([], ["default"]) }
output "dyn_alltrue"      { value = alltrue([true, true, true]) }
output "dyn_anytrue"      { value = anytrue([false, true, false]) }
output "dyn_can"          { value = can(tonumber("Satvik")) } 
output "col_length"       { value = length(["Riya", "Karan", "Amit"]) }
output "col_contains"     { value = contains(["AWS", "Azure", "GCP"], "AWS") }
output "col_index"        { value = index(["Dev", "Sec", "Ops"], "Sec") }
output "col_concat"       { value = concat(["Riya"], ["Karan", "Satvik"]) }
output "col_distinct"     { value = distinct(["Riya", "Riya", "Amit"]) }
output "col_element"      { value = element(["Amit", "Riya", "Satvik"], 2) }
output "col_keys"         { value = keys({name = "Satvik", role = "Engineer"}) }
output "col_values"       { value = values({name = "Satvik", role = "Engineer"}) }
output "col_lookup"       { value = lookup({env = "dev"}, "env", "default") }
output "col_merge"        { value = merge({a = 1}, {b = 2}, {c = 3}) }
output "col_zipmap"       { value = zipmap(["name", "city"], ["Satvik", "Lucknow"]) }
output "col_slice"        { value = slice(["Mon","Tue","Wed","Thu"], 0, 3) }
output "col_compact"      { value = compact(["Riya", "", "Karan", ""]) }
output "col_sort"         { value = sort(["Zoya", "Amit", "Karan"]) }
output "col_setproduct"   { value = setproduct(["A", "B"], ["1", "2"]) }
output "col_tolist"       { value = tolist(["A", "B", "C"]) }
output "col_toset"        { value = toset(["A", "B", "C"]) }
output "col_tomap"        { value = tomap({Satvik = "DevOps", Riya = "Tester"}) }

#structure_functions
output "struct_transpose" { value = transpose({name = ["Satvik"], role = ["Engineer"]}) }
output "struct_zipmap"    { value = zipmap(["name","role"], ["Riya","Tester"]) }

#math functions
output "math_pow"         { value = pow(2, 5) }
output "math_log"         { value = log(100, 10) }
output "math_parsient"         { value =parseint("100",10) }


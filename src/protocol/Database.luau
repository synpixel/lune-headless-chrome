-- this file was automatically generated and not intended for manual editing
export type DatabaseId = string
export type Database = { id: DatabaseId, domain: string, name: string, version: string }
export type Error = { message: string, code: number }
return {
	disable = "Database.disable",
	enable = "Database.enable",
	executeSQL = "Database.executeSQL",
	getDatabaseTableNames = "Database.getDatabaseTableNames",
	addDatabase = "Database.addDatabase",
}

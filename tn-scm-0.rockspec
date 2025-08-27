rockspec_format = "1.0"
package = "tn"
version = "scm-0"
source = {
	url = "git://github.com/gorjusborg/tn",
}
description = {
	homepage = "https://brandon.acknsyn.com/tn",
	license = "MIT <http://opensource.org/licenses/MIT>",
}
build = {
	type = "builtin",
	modules = {
		["tn.cli"] = "lib/tn/cli.lua",
		["tn.core"] = "lib/tn/core.lua",
		["tn.runner"] = "lib/tn/runner.lua",
		["tn.version"] = "lib/tn/version.lua",
	},
	install = {
		bin = {
			["tn"] = "bin/tn.lua",
		},
	},
}
dependencies = {
	"lua >= 5.1",
	"fun >= 0.1.3-1",
	"luafilesystem >= 1.8.0-1",
}

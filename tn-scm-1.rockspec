rockspec_format = "3.0"
package = "tn"
version = "{{version}}-1"
source = {
	url = "https://github.com/gorjusborg/tn/releases/download/v{{version}}/tn-{{version}}-1.all.rock",
}
description = {
	homepage = "https://brandon.acknsyn.com/tn",
	license = "MIT <http://opensource.org/licenses/MIT>",
	labels = { "cli", "note-taking" },
}
build = {
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

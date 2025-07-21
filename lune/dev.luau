local process = require("@lune/process")
local task = require("@lune/task")

process.exec("rojo", { "sourcemap", "-o", "sourcemap.json", "--include-non-scripts" }, {
	stdio = "inherit",
})

task.spawn(process.exec, "ovjo", { "sync", "-i", "out", "--watch" }, {
	stdio = "inherit",
	env = {
		OVJO_LOCALE = "en",
	}
} :: any)

-- TO-DO: Add watch for .umap and syncback

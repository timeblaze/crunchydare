local process = require("@lune/process")

process.exec("lune", { "run", "generate" }, {
	stdio = "inherit",
})
process.exec("ovjo", { "build", "-o", "out" }, {
	stdio = "inherit",
	env = {
		OVJO_LOCALE = "en",
	}
})
process.exec("lune", { "run", "ovdr", "studio" }, {
	stdio = "inherit",
})

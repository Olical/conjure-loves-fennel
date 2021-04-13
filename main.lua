local fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)
require("game")
require("repl")

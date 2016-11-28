local assert       = require "luassert"
local Reachability = require "graph.reachability"
local Marking      = require "marking"
local Petrinet     = require "petrinet"
local petrinet     = Petrinet.create ()

petrinet.p1 = petrinet:place (1) --place 1 with 1 token
petrinet.p2 = petrinet:place (0) --place 2 with 0 token
petrinet.p3 = petrinet:place (0) --place 3 with 0 token
petrinet.p4 = petrinet:place (0) --place 4 with 0 token


--transition t1
petrinet.t1  = petrinet:transition {
  petrinet.p1 - 1,
  petrinet.p2 + 1,
}


--transition t2
petrinet.t2  = petrinet:transition {
  petrinet.p2 - 1,
  petrinet.p3 + 1,
}


--transition t3
petrinet.t3  = petrinet:transition {
  petrinet.p3 - 1,
  petrinet.p4 + 1,
}

it ("can compute the reachability graph of a linear Petri net", function ()
  local reachability    = Reachability.create ()
  -- pass the `petrinet` variable (the Petri net instance)
  -- to the `reachability` algorithm:
  local initial, states = reachability (petrinet)
  -- check number of states in the reachability graph:
  assert.are.equal (#states, 4)
  -- check that transition `t` is fired from the initial state,
  -- and thus has a successor state:
  assert.is_not_nil (initial.successors [petrinet.t1])
)
end)

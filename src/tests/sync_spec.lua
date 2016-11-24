local assert       = require "luassert"
local Reachability = require "graph.reachability"
local Marking      = require "marking"
local Petrinet     = require "petrinet"
local petrinet     = Petrinet.create ()

petrinet.p1 = petrinet:place (1) --place 1 avec 1 jeton
petrinet.p2 = petrinet:place (1) --place 2 avec 1 jeton
petrinet.p3 = petrinet:place (0) --place 3 avec 0 jeton

--transition t : pre=(p1,p2) post=(p3)
petrinet.t  = petrinet:transition {
  petrinet.p1 - 1,
  petrinet.p2 - 1,
  petrinet.p3 + 1,
}

it ("can compute the reachability graph of a SYNC Petri net", function ()
  local reachability    = Reachability.create ()
  -- pass the `petrinet` variable (the Petri net instance)
  -- to the `reachability` algorithm:
  local initial, states = reachability (petrinet)
  -- check number of states in the reachability graph:
  assert.are.equal (#states, 2)
  -- check that transition `t` is fired from the initial state,
  -- and thus has a successor state:
  assert.is_not_nil (initial.successors [petrinet.t])
  -- check that second state has marking { p1 = 0, p2 = 0, p3 = 1 }
  assert.are.equal (initial.successors [petrinet.t].marking, Marking.create {
    [petrinet.p1] = 0,
    [petrinet.p2] = 0,
    [petrinet.p3] = 1,
  })
end)

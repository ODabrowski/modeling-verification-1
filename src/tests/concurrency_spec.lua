local assert       = require "luassert"
local Reachability = require "graph.reachability"
local Marking      = require "marking"
local Petrinet     = require "petrinet"
local petrinet     = Petrinet.create ()

petrinet.p1 = petrinet:place (1)
petrinet.p2 = petrinet:place (1) 
petrinet.p3 = petrinet:place (0)
petrinet.p4 = petrinet:place (0)
petrinet.p5 = petrinet:place (0) 



--transition t1
petrinet.t1  = petrinet:transition {
  petrinet.p1 - 1,
  petrinet.p3 + 1,
}


--transition t2
petrinet.t2  = petrinet:transition {
  petrinet.p2 - 1,
  petrinet.p4 + 1,
}


--transition t3
petrinet.t3  = petrinet:transition {
  petrinet.p3 - 1,
  petrinet.p4 - 1,
  petrinet.p5 + 1,
}

--Example of how to test a succession of firering of transitions and see their marking ( here t1 and t3)
-- assert.are.equal (initial.successors [petrinet.t1].successors.[petrinet.t2].marking, Marking.create {
it ("can compute the reachability graph of a concurrent Petri net", function ()
  local reachability    = Reachability.create ()
  -- pass the `petrinet` variable (the Petri net instance)
  -- to the `reachability` algorithm:
  local initial, states = reachability (petrinet)
  -- check number of states in the reachability graph:
  assert.are.equal (#states, 5)
  -- check that transition `t1` is fired from the initial state,
  -- and thus has a successor state:
  assert.is_not_nil (initial.successors [petrinet.t1])
  -- check that final state (after firering t3) has marking { p1 = 0, p2 = 0, p3 = 0, p4 = 0, p5=1 }
  assert.are.equal (initial.successors [petrinet.t3].marking, Marking.create {
    [petrinet.p1] = 0,
    [petrinet.p2] = 0,
    [petrinet.p3] = 0,
    [petrinet.p4] = 0,
    [petrinet.p5] = 1,
  })
end)

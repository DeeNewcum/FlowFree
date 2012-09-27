## Similar games

The game is known by the names "[Numberlink](http://en.wikipedia.org/wiki/Numberlink)" and "Flow Free".  "Puzzleland Park" is a similar puzzle.

## Permutations

The solution space can be viewed as a grid of arrows.  For example, for a 5x5 board:

<table>
<tr><td>↓<td>→<td>↓<td>→<td>←
<tr><td>→<td>←<td>→<td>←<td>↑
<tr><td>↓<td>→<td>↑<td>→<td>↓
<tr><td>→<td>←<td>→<td>←<td>↑
<tr><td>→<td>↑<td>→<td>↑<td>↑
</table>

Each cell has four possibilities, so the number of permutations is approximately 4^n².

However, corners cells only have two possibilities, and edge cells only have three.  So the number of permutations is closer to:

4^2 * 3^(4*(n-2)) * 4^((n-2)^2)

<table>
<tr><th>n<th>permutations
<tr><td>4<td>~10⁷
<tr><td>5<td>~10¹²
<tr><td>6<td>~10¹⁸
<tr><td>7<td>~10²⁵
<tr><td>8<td>~10³⁴
<tr><td>9<td>~10⁴⁴
</table>

That's still an overestimate, however.  For each pair of start+end points, only the start-point permutes through all possible directions; once the end-point is reached, you don't travel to another cell.  So the end-point cells aren't counted.  This is more difficult to calculate (because end-points may be in the interior or on the edges/corners).  As a rough guide though, this may reduce the permutations by up to 10⁴.

## Current status

This project is mothballed for now.   The solver isn't alpha quality yet.  Small portions of the recursive explorer are written, but it is nowhere near being in a working state.

[This C version](https://github.com/imos/Puzzle/tree/master/NumberLink) works, and is quite fast.  If you're only looking to solve a specific board that you're stuck on, use that.

I was disheartened somewhat after discovering the number of permutations required to solve this via brute-force.   I don't know how the C version works exactly, but it's likely that a constraint-propagation approach would be much faster (for instance, see [this writeup](http://mellowmelon.wordpress.com/2010/07/24/numberlink-primer/) on how Numberlink boards are solved by humans. It is clear that such an approach would reduce the number of permutations greatly)

## Other solvers

* [github.com/~imos](https://github.com/imos/Puzzle/tree/master/NumberLink)
* ["Recursive Path-finding in a Dynamic Maze with Modified Tremaux's Algorithm"](http://www.waset.org/journals/waset/v60/v60-159.pdf)

## Permutations

The solution space can be viewed as a grid of arrows.  For example, for a 4x4 board:

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

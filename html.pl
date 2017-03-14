
html(L) :-
    format("
<table style='text-align: center; vertical-align: top;'>", []),
    html(L, '  '),
    format("
</table>
", []).

html([H], INDENT0) :-
    !,
    format("
~w<td style='text-align: center; vertical-align: top;'>~w</td></tr>", [INDENT0, H]).
html([H | D], INDENT0) :-
    format("
~w<td style='text-align: center; vertical-align: top;'><table style='text-align: center; vertical-align: top;'>
~w  <tr><td style='text-align: center; vertical-align: top;'>~w</td></tr>", [INDENT0, INDENT0, H]),
    (D = [] -> true;
     (atom_concat(INDENT0, '  ', INDENT1),
      format("
~w  <tr>", [INDENT0]),
      htmldtrs(D, INDENT1),
      format("
~w  </tr>", [INDENT0]))),
    format("
~w</table></td>", [INDENT0]).

htmldtrs([], _INDENT).
htmldtrs([H | D], INDENT) :-
    html(H, INDENT),
    htmldtrs(D, INDENT).
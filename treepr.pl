
biggestSpan(B, SPAN) :-
    -zero@X,
    X <> [compact, saturated],
    start@X -- SX,
    end@X -- EX,
    span@X -- SPANX,
    findall(D-X, (X, D is SX-EX, 0 is SPANX /\ SPAN), L0),
    sort(L0, [_-B | L1]).

biggest2(B1, B2) :-
    biggestSpan(B1, 0),
    ((biggestSpan(B2, span@B1), end@B2-start@B2 > 3) -> true; true).

sublist(0, J, L0, R) :-
    !,
    sublistremainder(J, L0, R).
sublist(I, K, [_ | L0], R) :-
    J is I-1,
    sublist(J, K, L0, R).

sublistremainder(0, _, []) :-
    !.
sublistremainder(I, [H | T], [H | R]) :-
    J is I-1,
    sublistremainder(J, T, R).

rebuildDtrs([], []) :-
    !.
rebuildDtrs([{theta@H1, surface@H1} | T0], [H1 | T1]) :-
    rebuild(H0, H1),
    rebuildDtrs(T0, T1).

rebuild([surface@T1 | DTRS], T1) :-
    rebuildDtrs(DTRS, dtrs@T1).

dwidth([], -10, X-X) :-
    !.
dwidth([H | T], W, X0-X2) :-
    width(H, W1, X0),
    X1 is X0+W1+10,
    dwidth(T, W2, X1-X2),
    W is W1+W2+10.

width(SIGN, W, X) :-
    with_output_to_chars(write(surface@SIGN), CHARS),
    length(CHARS, W1),
    dwidth(dtrs@SIGN, W2, X-_),
    max(W1, W2, W),
    width@SIGN -- W,
    xpos@SIGN is X+W/2.

width(SIGN, W) :-
    width(SIGN, W, 0).

height(SIGN) :-
    height(SIGN, 2).

height(SIGN, I) :-
    ypos@SIGN -- I,
    J is I+3,
    dHeight(dtrs@SIGN, J).

dHeight([], _I).
dHeight([H | T], I) :-
    height(H, I),
    dHeight(T, I).

makeJSTree(I) :-
    retrieve(I, X),
    rebuild(root@X, P),
    theta@P -- top,
    width(P, _),
    height(P),
    format('\
<html>
<head>
<script>\
	  
function drawLine(ctx, x1, y1, x2, y2){
ctx.beginPath();
ctx.strokeStyle = "black";
ctx.moveTo(8*x1, 21*y1);
ctx.lineTo(8*x2, 19*y2);
ctx.stroke();
}

function drawText(ctx, text, x, y){
ctx.fillText(text, 8*x, 20*y);
}
function showTree(){
    var canvas = document.getElementById("myCanvas");\n\
    var context = canvas.getContext("2d");\n\
', []),
    jsTree(P),
    format('\
}\
</script>
</head>
<body onload="try{showTree()}catch(e){alert(e)}">
<canvas id="myCanvas" width="900" height="900"></canvas>
</body></html>	  
', []).

convertInput(A, S1) :-
    atom(A),
    !,
    atom_chars(A, C),
    split(C, 32, S0),
    findall(X2,
	    (member(X0, S0),
	     split(X0, 0'+, X1),
	     findall(K1, (member(K0, X1), atom_chars(K1, K0)), X2)),
	    S1).
convertInput(S, S).

jsTree(SIGN) :-
    DTRS -- dtrs@SIGN,
    YPOS -- ypos@SIGN,
    (DTRS == [] -> J is YPOS+1; J = YPOS),
    J1 is J-2,
    format("drawText(context, '~w', ~w, ~w);~n", [theta@SIGN, xpos@SIGN, J1]),
    format("drawText(context, '~w', ~w, ~w);~n", [surface@SIGN, xpos@SIGN, J]),
    member(DTR, dtrs@SIGN),
    format("drawLine(context, ~w, ~w, ~w, ~w);~n", [xpos@SIGN, ypos@SIGN, xpos@DTR, ypos@DTR]),
    jsTree(DTR),
    fail.
jsTree(_).

jsParse(TEXT0) :-
    convertInput(TEXT0, TEXT1),
    (flag(quoteAtoms) -> true; set(quoteAtoms)),
    unset(quoteAtoms),
    nl,
    call_residue((with_output_to_chars((chartParse(TEXT1, _) -> true; true), _),
		  biggestSpan(P),
		  makeJSTree(index@P)),
		 _).


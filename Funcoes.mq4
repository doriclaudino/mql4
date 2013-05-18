/*
+ ordemTipo
	+ OP_BUY:buying position,
	+ OP_SELL:selling position,
	+ OP_BUYLIMIT:buy limit pending position,
	+ OP_BUYSTOP:buy stop pending position,
	+ OP_SELLLIMIT:sell limit pending position,
	+ OP_SELLSTOP:sell stop pending position.
+ numeroMagico
	+ 0: Sem filtro
+ simbolo
	+ Symbol():Simbolo do grafico
	+ EURUSD:Simbolo estático, varia de acordo com o seu banco.
*/
int CountTrades(int ordemTipo, int numeroMagico, string simbolo) {
	int intContador = 0;
	string stringAux = simbolo;
	int index = 0;

	if(OrdersTotal()<1) {
		return (0);
	} else {

		if(usaSimboloGrafico) stringAux = Symbol();

		for(index = OrdersTotal() - 1; index >= 0 ; index--) {
			if(OrderSelect(index,SELECT_BY_POS,MODE_TRADES) {
			if(OrderSymbol() == stringAux && OrderMagicNumber() == numeroMagico && OrderType() == ordemTipo) {
					intContador++;
				} else {
					continue;
				}
			}
		}
	}
	return (intContador);
}
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
	+ EURUSD:Simbolo estatico, varia de acordo com o seu banco.
*/
int TotalOrdens(int ordemTipo, int numeroMagico, string simbolo) {
	int contador = 0;
	int indice = 0;

	if(OrdersTotal()<1) {
		return (0);
	} else {
		for(indice = OrdersTotal() - 1; indice >= 0 ; indice--) {
			if(OrderSelect(indice,SELECT_BY_POS,MODE_TRADES)) {
			if(OrderSymbol() == simbolo && OrderMagicNumber() == numeroMagico && OrderType() == ordemTipo) {
					contador++;
				} else {
					continue;
				}
			}
		}
	}
	return (contador);
}



int GetOrdersTotal(int ordertype, int magicnumber, string symbol) {
	int count = 0;
	int index = 0;

	if(OrdersTotal()<1) {
		return (0);
	} else {
		for(index = OrdersTotal() - 1; index >= 0 ; index--) {
			if(OrderSelect(index,SELECT_BY_POS,MODE_TRADES)) {
			if(OrderSymbol() == symbol && OrderMagicNumber() == magicnumber && OrderType() == ordertype) {
					count++;
				} else {
					continue;
				}
			}
		}
	}
	return (count);
}


int SendOrder(int ordertype, int magicnumber, string symbol, double Lot, double slippage, string comment){
int ticket = 0;
      for(int n=5;n>=0;n--){
	  
		if(ordertype == OP_BUY)
			ticket = OrderSend(symbol,ordertype,Lot,Ask,slippage,0,0,comment,magicnumber,NULL,NULL); 
		else
			ticket = OrderSend(symbol,ordertype,Lot,Bid,slippage,0,0,comment,magicnumber,NULL,NULL); 			
		            
         int err = GetLastError();
         if (err == 0/* NO_ERROR */) break;
         if (!(err == 4/* SERVER_BUSY */ || err == 137/* BROKER_BUSY */ || err == 146/* TRADE_CONTEXT_BUSY */ || err == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
   return(ticket);   
}


double GetLotsTotal(int ordertype,int magicnumber, string symbol) {
   int total = GetOrdersTotal(ordertype,magicnumber,symbol);
   int index = 0;
   double lotstotal = 0;
	
	if(total<1){
		return(0);
	}else{   
		for (index = total - 1; index >= 0; index--) {
			if(OrderSelect(index,SELECT_BY_POS,MODE_TRADES)) {
				if (OrderSymbol() == symbol && OrderMagicNumber() == magicnumber && OrderType() == ordertype) {
					lotstotal += OrderLots();
				}
			}
		}
	}		
   return (lotstotal);
}

double GetLastOpenPrice(int ordertype,int magicnumber, string symbol) {
   int total = GetOrdersTotal(ordertype,magicnumber,symbol);
   double oldprice = 0;
   int index = 0;
   int oldticket = 0;
   int newticket = 0;
   
      for (index = total - 1; index >= 0; index--) {
         if(OrderSelect(index,SELECT_BY_POS,MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderMagicNumber() == magicnumber && OrderType() == ordertype) {
               oldticket = OrderTicket();
				if (oldticket > newticket) {
					oldprice = OrderOpenPrice();
					newticket = oldticket;
				}
            }
         }
      }     
   return (oldprice);
}

double GetLastOpenLot(int ordertype,int magicnumber, string symbol) {
   int total = GetOrdersTotal(ordertype,magicnumber,symbol);
   double lastlot = 0;
   int index = 0;
   int oldticket = 0;
   int newticket = 0;
   
      for (index = total - 1; index >= 0; index--) {
         if(OrderSelect(index,SELECT_BY_POS,MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderMagicNumber() == magicnumber && OrderType() == ordertype) {
               oldticket = OrderTicket();
				if (oldticket > newticket) {
					lastlot = OrderLots();
					newticket = oldticket;
				}
            }
         }
      }     
   return (lastlot);
}

double GetMedianPrice(int ordertype, int magicnumber, string symbol){
   int total = GetOrdersTotal(ordertype,magicnumber,symbol);
   double medianprice = 0;
   double count = 0;
   int index = 0;
   
	if(total<1) {
		return (0);
	} else {
		for(index = total - 1; index >= 0 ; index--) {
			if(OrderSelect(index,SELECT_BY_POS,MODE_TRADES)) {
			if(OrderSymbol() == symbol && OrderMagicNumber() == magicnumber && OrderType() == ordertype) {
					medianprice += OrderOpenPrice() * OrderLots();
					count += OrderLots();
				} else {
					continue;
				}
			}
		}
	}
	if(count>0){
		medianprice = NormalizeDouble(medianprice / count,Digits);
	}
	return (medianprice);
}

double GetTakeProfit(int ordertype, double price, double stop){
double newtakeprofit = 0;

	if(stop == 0){
		return(0);
	}else{
		if(ordertype == OP_BUY){
			newtakeprofit = price + stop * Point;
		}
		if(ordertype == OP_SELL){
			newtakeprofit = price - stop * Point;
		}
	}
	return(newtakeprofit);
}


void SyncProfit(int ordertype,int magicnumber, string symbol, double lucro){  
int total = GetOrdersTotal(ordertype,magicnumber,symbol); 
int index = 0;
bool modify = false;

	if(total<1){
		return(0);
	}else{   
		for (index = total - 1; index >= 0; index--) {
			if(OrderSelect(index,SELECT_BY_POS,MODE_TRADES)) {
				if (OrderSymbol() == symbol && OrderMagicNumber() == magicnumber && OrderType() == ordertype) {
				
					int    TK = OrderTicket();
					double TP = OrderTakeProfit();
					double SL = OrderStopLoss();
					double OP = OrderOpenPrice();
					double newtakeprofit = 0;
					double medianprice = GetMedianPrice(ordertype,magicnumber,symbol);

					switch(OrderType())	{
						case 0://buy
							if(TP != GetTakeProfit(ordertype,medianprice, lucro)){
								modify = true;    
								newtakeprofit = GetTakeProfit(ordertype,medianprice, lucro);     
							}   
						break;
						
						case 1://sell
							if(TP != GetTakeProfit(ordertype,medianprice, lucro)){
								modify = true;    
								newtakeprofit = GetTakeProfit(ordertype,medianprice, lucro);        
							}   					
						break;
					}//exit switch
					
					if(modify == false) continue;
					
					OrderModify(TK,OP,SL,newtakeprofit,0);					
					
				}
			}
		}
	}	
}
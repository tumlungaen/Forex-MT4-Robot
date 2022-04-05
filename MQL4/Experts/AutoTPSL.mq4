//+------------------------------------------------------------------+
//|                                                     AutoTPSL.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

int OnInit() {
   return(INIT_SUCCEEDED);
}//end function
void OnDeinit(const int reason)  {
//---
   
}//end function

int LastOrder = -1 ;
void OnTick()  {
   double ATR = 0 ;
   double TP = 0 ;
   double SL = 0 ;
   double Price = 0 ;
   int t = 0 ;
   int i = 0 ;
   if( LastOrder != OrdersTotal() && OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( ( OrderStopLoss() == 0 || OrderTakeProfit() == 0 ) && OrderMagicNumber() == 0 ) {
               ATR = iATR( OrderSymbol(), PERIOD_H1, 14, 1 ) ;
               
               if( OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP ) {
                  TP = OrderOpenPrice() + ATR * 9 ;
                  SL = OrderOpenPrice() - ATR * 3 ;
               } else if( OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP ) {
                  TP = OrderOpenPrice() - ATR * 9 ;
                  SL = OrderOpenPrice() + ATR * 3 ;
               }//end if
               t = OrderModify( OrderTicket(), OrderOpenPrice(), SL, TP, 0 ) ;
               
            }//end if
         }//end if
      }//end for
      LastOrder = OrdersTotal() ;
   }//end if
   
}//end function


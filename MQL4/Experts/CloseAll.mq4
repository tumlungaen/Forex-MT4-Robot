//+------------------------------------------------------------------+
//|                                                     CloseAll.mq4 |
//|                              Copyright 2022, Thailand Fx Warrior |
//|                                https://www.thailandfxwarrior.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Thailand Fx Warrior"
#property link      "https://www.thailandfxwarrior.com"
#property version   "1.00"
#property strict

input double TP_Dollar = 1700 ;

int OnInit()  {
   return(INIT_SUCCEEDED);
}//end function

void OnDeinit(const int reason)  {
}//end function

int LastBar = -1 ;

void OnTick()  {
   string s = "" ;

   s += "\n  " + "--------------" ;
   s += "\n  " + "Current Profit = " + DoubleToStr( AllProfit(), 2 ) ;
   s += "\n  " + "" ;
   s += "\n  " + "" ;
   s += "\n  " + "" ;

   Comment( s ) ;
   
   if( LastBar != iBars( Symbol(), PERIOD_M1 ) ) {
      if( AllProfit() > TP_Dollar ) CloseAll() ;
      LastBar = iBars( Symbol(), PERIOD_M1 ) ;
   }//end if
   
}//end function

double AllProfit() {
   double Output = 0 ;
   if( OrdersTotal() > 0 ) {
      for( int i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            Output += OrderProfit() + OrderCommission() + OrderSwap() ;
         }//end if
      }//end for
   }//end if
   return Output ;
}//end function

void CloseAll() {
   int Output = 0 ;
   int Exit   = 0 ;
   int    i   = 0 ;
   int    t   = 0 ;
   double Bids = MarketInfo( Symbol(), MODE_BID ) ; 
   double Asks = MarketInfo( Symbol(), MODE_ASK ) ;
   for( int j = 0 ; j < 10 ; j++ ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            Bids = MarketInfo( OrderSymbol(), MODE_BID ) ; 
            Asks = MarketInfo( OrderSymbol(), MODE_ASK ) ;
   
            if( OrderType() == OP_BUY  ) t = OrderClose( OrderTicket(), OrderLots(), Bids, 3 ) ;
            if( OrderType() == OP_SELL ) t = OrderClose( OrderTicket(), OrderLots(), Asks, 3 ) ;
            if( OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP ) t = OrderDelete( OrderTicket() ) ;
         }//end if
      }//end for
   }//end for
}//end function
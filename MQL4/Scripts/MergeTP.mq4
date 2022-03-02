//+------------------------------------------------------------------+
//|                                                      MergeTP.mq4 |
//|                              Copyright 2020, Thailand Fx Warrior |
//|                                 http://www.thailandfxwarrior.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Thailand Fx Warrior"
#property link      "http://www.thailandfxwarrior.com"
#property version   "1.00"
#property strict
#property show_inputs

enum MergeEnum {
    MergeBuy ,      // Buy
    MergeSell ,     // Sell
} ;
input MergeEnum MergeMode = MergeBuy ; //Merge Mode (Buy/Sell)
input int min_pts = 50 ; //Merge Points (Pts)

void OnStart()  {
   if( MergeMode == MergeSell ) Merge( OP_SELL ) ;
   else                         Merge( OP_BUY ) ;
}//end function

string Product = Symbol() ;
string EA_Name = "SP" ;

double AllLot( string Products, int Type ) {
   double Output = 0;
   int    i      = 0;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) && OrderSymbol() == Symbol() ) {
            if( OrderSymbol() == Products && OrderType() != OP_SELLLIMIT && OrderType() != OP_SELLSTOP && OrderType() != OP_BUYLIMIT && OrderTicket() != OP_BUYSTOP ) {
               if(      Type == OP_BUY && OrderType() == OP_BUY ) Output += OrderLots() ;
               else if( Type == OP_SELL && OrderType() == OP_SELL ) Output += OrderLots() ;
            }//end if
         }//end if
      }//end for
   }//end if
   return Output;
}//end function

double AllPrice( string Products, int Type ) {
   double Output = 0;
   int    i      = 0;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) && OrderSymbol() == Symbol() ) {
            if( OrderSymbol() == Products && OrderType() != OP_SELLLIMIT && OrderType() != OP_SELLSTOP && OrderType() != OP_BUYLIMIT && OrderTicket() != OP_BUYSTOP ) {
               if(      Type == OP_BUY && OrderType() == OP_BUY )   Output += OrderOpenPrice() * OrderLots();
               else if( Type == OP_SELL && OrderType() == OP_SELL ) Output += OrderOpenPrice() * OrderLots();
            }//end if
         }//end if
      }//end for
   }//end if
   return Output;
}//end function

void Merge( int Type ) {
   double avg_buy  = 0 ;
   double avg_sell = 0 ;
   int merge_pts = 0 ;
   int i = 0 ;
   int t = 0 ;
   Product = Symbol() ;
   
   merge_pts = min_pts ;
   if( merge_pts <= MarketInfo( Product, MODE_STOPLEVEL ) ) merge_pts = MarketInfo( Product, MODE_STOPLEVEL ) ;

   if( merge_pts <= 0 ) {
      if( AllLot(Product, OP_BUY )  > 0 ) avg_buy  = merge_pts * MarketInfo( Product, MODE_POINT ) ;
      if( AllLot(Product, OP_SELL ) > 0 ) avg_sell = merge_pts * MarketInfo( Product, MODE_POINT ) ;
   } else {
      if( AllLot(Product, OP_BUY )  > 0 ) avg_buy  = ( AllPrice(Product, OP_BUY)  / AllLot(Product, OP_BUY ) ) + ( merge_pts * MarketInfo( Product, MODE_POINT ) ); 
      if( AllLot(Product, OP_SELL ) > 0 ) avg_sell = ( AllPrice(Product, OP_SELL) / AllLot(Product, OP_SELL) ) - ( merge_pts * MarketInfo( Product, MODE_POINT ) ); 
   }//end if
   
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) && OrderSymbol() == Symbol() ) {
         if( OrderType() == OP_BUY && Type == OP_BUY ) {
            t = OrderModify( OrderTicket(), OrderOpenPrice(), 0, avg_buy, 0 ) ;
            if( t == 0 ) t = OrderModify( OrderTicket(), OrderOpenPrice(), avg_buy, 0, 0 ) ;
         } else if( OrderType() == OP_SELL && Type == OP_SELL ) {
            t = OrderModify( OrderTicket(), OrderOpenPrice(), 0, avg_sell, 0 ) ;
            if( t == 0 ) t = OrderModify( OrderTicket(), OrderOpenPrice(), avg_sell, 0, 0 ) ;
         }//end if
      }//end if
   }//end for
}//end function

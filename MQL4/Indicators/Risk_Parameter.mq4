//+------------------------------------------------------------------+
//|                                                RiskParameter.mq4 |
//|                              Copyright 2022, Thailand Fx Warrior |
//|                                https://www.thailandfxwarrior.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Thailand Fx Warrior"
#property link      "https://www.thailandfxwarrior.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
   return(INIT_SUCCEEDED);
}//end function

void OnDeinit(const int reason) {
   ObjectsDeleteAll( 0, Symbol() + "BL" ) ;
   ObjectsDeleteAll( 0, Symbol() + "SL" ) ;
   ObjectsDeleteAll( 0, Symbol() + "BT" ) ;
   ObjectsDeleteAll( 0, Symbol() + "ST" ) ;
}//end function

int LastBar = 0 ;
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   int i = 0 ;
   double Avg_Buy = 0 ;
   double Avg_Sell = 0 ;
   double Sum_Buy = 0 ;
   double Sum_Sell = 0 ;
   int count_Buy = 0 ;
   int count_Sell = 0 ;
   
   if( LastBar != Bars ) {
      
      //----| Find Average Price
      for( i = 0 ; i < OrdersHistoryTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_HISTORY ) ) {
            if( OrderSymbol() == Symbol() ) {
               if( OrderType() == OP_BUY ) {
                  Sum_Buy  += OrderOpenPrice() ;
                  count_Buy++ ;
               } else if( OrderType() == OP_SELL ) {
                  Sum_Sell += OrderOpenPrice() ;
                  count_Sell++ ;
               }//end if
            }//end if
         }//end if
      }//end for
      
      if( count_Buy > 0 ) Avg_Buy = Sum_Buy / count_Buy ;
      if( count_Sell > 0 ) Avg_Sell = Sum_Sell / count_Sell ;
      
      DrawLine( Avg_Buy, "B", ForestGreen ) ;
      DrawLine( Avg_Sell, "S", Salmon ) ;
      
      DrawText( "B", "Risk Parameter: Buy @" + DoubleToStr( Avg_Buy, Digits ) , 9, Avg_Buy , ForestGreen ) ;
      DrawText( "S", "Risk Parameter: Sell @" + DoubleToStr( Avg_Sell, Digits ), 9, Avg_Sell, Salmon ) ;
      
      LastBar = Bars ;
   }//end if
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

void DrawLine( double TargetPrice, string Side = "B", color C = ForestGreen )  {
   ObjectCreate(  Symbol() + Side + "L", OBJ_HLINE, 0, 0, 0 );            //Declare HLine Object
   ObjectSet(     Symbol() + Side + "L", OBJPROP_COLOR, C );              //Color of this Object
   ObjectSet(     Symbol() + Side + "L", OBJPROP_STYLE, STYLE_SOLID );    //Set Line to Solid
   ObjectSet(     Symbol() + Side + "L", OBJPROP_WIDTH, 1 );              //Set Width of Line
   ObjectSet(     Symbol() + Side + "L", OBJPROP_PRICE1, TargetPrice );   // Move
}//end function

void DrawText( string label, string text, int font_size, double Price = 0, color FontColor = White )  {
   ObjectCreate( Symbol() + label + "T", OBJ_TEXT, 0, 0, 0, 0 ) ;
   ObjectSetText( Symbol() + label + "T", text, font_size, "Tahoma", FontColor ) ;
   ObjectSet( Symbol() + label + "T", OBJPROP_TIME1, TimeCurrent() ) ;
   ObjectSet( Symbol() + label + "T", OBJPROP_PRICE1, Price ) ;
}//end function

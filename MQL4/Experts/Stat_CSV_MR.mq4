//+------------------------------------------------------------------+
//|                              Copyright 2020, Thailand Fx Warrior |
//|                                 http://www.thailandfxwarrior.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Thailand Fx Warrior"
#property link      "https://www.thailandfxwarrior.com"
#property version   "1.00"
#property strict

string EA_Name = "MR_" ;

 string x1 = "====| L I N E    A P I |====" ;    //-----------------------------------------
 string LineSDToken   = "";
 int    input_DD_Pts  = 0 ;  //Drawdown (pts)
 int    input_DD_Bars = 0 ;  //Drawdown (bars)

input string x2 = "====| B B |====" ;    //-----------------------------------------
input int    BB_Period = 110 ;
input double BB_SD     = 2.5 ;

input string x3 = "====| F I L E |====" ;    //-----------------------------------------
input string      f_input     = "tr";              // ----| File Name
string FileName = Symbol() + "_" + f_input + "_" + IntegerToString( Period() ) + "min" + ".csv" ;

enum LineAlertEnum {
   AlertOff ,  //Off
   AlertOn  ,  //On
} ;
 LineAlertEnum LineAlertMode = AlertOff ;  // Line Alert Mode (On/Off)

 int StoHigh = 85 ;   //
 int StoLow  = 15 ;
enum DrawLineEnum {
   DrawOff ,   //Off
   DrawOn  ,   //On
} ;
input DrawLineEnum DrawMode = DrawOff ;         //

enum HeaderEnum {
   HeaderOff ,    //Off
   HeaderOn  ,    //On
} ;
input HeaderEnum HeaderMode = HeaderOn ; //Header Mode (On/Off)

enum ExitTypeEnum {
   ExitBidAsk ,      //Bid / Ask
   ExitHighLow  ,    //High / Low
} ;
input ExitTypeEnum ExitType = ExitHighLow ; //Exit Type

enum CaptureEnum {
   CaptureOff ,   //Off
   CaptureOn  ,   //On
} ;
input CaptureEnum CaltureMode = CaptureOff ;    //Capture Mode (On/Off)

enum CloseEnum {
   CloseBy1SD ,   //1SD
   CloseByMean ,  //Mean
} ;
input CloseEnum CloseMode = CloseBy1SD ; //Exit Order Method

input int s_width = 600 ;  // Capture - Width
input int s_high  = 400 ;  // Capture - High

int OnInit() {
//---
   sFileName   = FileName ;
   if( HeaderMode == HeaderOn ) {
   sString = "" ;
      sString = "" +
      "No\tTactic\tSymbol\tTF\tOrder\tEntry_Date\tEntry_Price\tSL_Price\tEntryBB\tEntryDayString\tExit_Date\tExit_Price\tDD_Price\tHolding_Bar\tMax_Profit_Price\tBars_Max_Profit\tBars_DD\tDate_Num\tExitDate(String)\tRR\tP/L(pts)\tSL(pts)\tDD(pts)\tMaxProfit(pts)\n"
   ;
   }//end if
//---
   return( INIT_SUCCEEDED );
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   
   if( CurrentOrder == "Buy" ) {
      sString += Data_2( Bid, Digits ) ; CurrentOrder = "" ;
   } else if( CurrentOrder == "Sell" ) {
      sString += Data_2( Ask, Digits ) ; CurrentOrder = "" ;
   }//end if
   
   fnWriteFile() ;
}//end function
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void DrawLine( string EA_Names, color C = ForestGreen )  {
   if( DrawMode == DrawOn ) {
      ObjectCreate( EA_Names + "Line", OBJ_VLINE, 0, TimeCurrent(), Ask ) ;
      ObjectSet(     EA_Names + "Line", OBJPROP_COLOR, C );              //Color of this Object
      ObjectSet(     EA_Names + "Line", OBJPROP_STYLE, C == Salmon ? STYLE_SOLID : STYLE_DASH );    //Set Line to Solid
      ObjectSet(     EA_Names + "Line", OBJPROP_WIDTH, 1 );              //Set Width of Line
   }//end if
}//end function

int obj = 0 ;
int LastBar = 0 ;

int MarkBar1 = 0 ;
int MarkBar2 = 0 ;
int MarkBar3 = 0 ;
int MarkBar4 = 0 ;
int MarkBar5 = 0 ;

datetime T1 = 0 ;
datetime T2 = 0 ;
datetime T3 = 0 ;
datetime T4 = 0 ;
datetime T5 = 0 ;

double HighPrice = -9999999 ;
double LowPrice = 9999999 ;
double CurrentHigh = 0 ;
double CurrentLow = 0 ;

double DD_Price  = Ask ;
double Max_Price = Ask ;
int    DD_Bar    = 0 ;
int    Max_Bar   = 0 ;
double Order_Price = 0 ;

int step = 1 ;
void OnTick() {
   //MarkSto() ;
   EntryAndExit() ;
   MarkBars() ;   
}//end function

void MarkBars() {
   if( CurrentOrder == "Buy" ) {
      if( Ask > Max_Price && Ask > Order_Price ) {
         Max_Price = Ask ;
         Max_Bar = Bars ;
      }//end if
      
      if( Ask < Order_Price && Ask < DD_Price ) {
         DD_Price = Ask ;
         DD_Bar = Bars ;
      }//end if
   }//end if
   
   if( CurrentOrder == "Sell" ) {
      if( Bid < Max_Price && Bid < Order_Price ) {
         Max_Price = Bid ;
         Max_Bar = Bars ;
      }//end if
      
      if( Bid > Order_Price && Bid > DD_Price ) {
         DD_Price = Bid ;
         DD_Bar = Bars ;
      }//end if
   }//end if
}//end function

string SignalFromMeanReverse() {
   string Output = "" ;
   int delay = 1 ;
   double RSI     = iRSI( Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, delay ) ;
   
   double UBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
   double LBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
   
   double UBand1SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, 1, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
   double LBand1SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, 1, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
   
   double MBand   = iMA( Symbol(), PERIOD_CURRENT, BB_Period, 0, MODE_SMA, PRICE_CLOSE, delay ) ;
   double Cs      = iClose( Symbol(), PERIOD_CURRENT, delay ) ;
   
   if( OrdersTotal() == 0 ) {
      
      if( RSI > 70 && Cs > UBand2SD ) {
         Output = "Sell" ;
      } else if( RSI < 30 && Cs < LBand2SD ) {
         Output = "Buy" ;
      }//end if
      
   } else { 
      bool ExitCondition = FALSE ;
      
      if( CloseMode == CloseBy1SD ) {
         ExitCondition = FALSE ;
         if( ExitType == ExitBidAsk )        ExitCondition = CurrentOrder == "Buy" && Bid >= LBand1SD ;
         else if( ExitType == ExitHighLow )  ExitCondition = CurrentOrder == "Buy" && iHigh( Symbol(), PERIOD_CURRENT, delay ) >= LBand1SD ;
         if( ExitCondition ) {
            Output = "CloseBuy" ;
         }//end if
         
         ExitCondition = FALSE ;
         if( ExitType == ExitBidAsk )        ExitCondition = CurrentOrder == "Sell" && Ask <= UBand1SD ;
         else if( ExitType == ExitHighLow )  ExitCondition = CurrentOrder == "Sell" && iLow( Symbol(), PERIOD_CURRENT, delay ) <= UBand1SD ;
         if( ExitCondition ) {
            Output = "CloseSell" ;
         }//end if
      } else if( CloseMode == CloseByMean ) {
         ExitCondition = FALSE ;
         if( ExitType == ExitBidAsk )        ExitCondition = CurrentOrder == "Buy" && Bid >= MBand ;
         else if( ExitType == ExitHighLow )  ExitCondition = CurrentOrder == "Buy" && iHigh( Symbol(), PERIOD_CURRENT, delay ) >= MBand ;
         if( ExitCondition ) {
            Output = "CloseBuy" ;
         }//end if
         
         ExitCondition = FALSE ;
         if( ExitType == ExitBidAsk )        ExitCondition = CurrentOrder == "Sell" && Ask <= MBand ;
         else if( ExitType == ExitHighLow )  ExitCondition = CurrentOrder == "Sell" && iLow( Symbol(), PERIOD_CURRENT, delay ) <= MBand ;
         if( ExitCondition ) {
            Output = "CloseSell" ;
         }//end if
      }//end if
   }//end if
   
   return Output ;
}//end function

double BBW() {
   double Output = 0 ;
      
   double UBand2SD = iBands( Symbol(), PERIOD_CURRENT, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 1 ) ;
   double LBand2SD = iBands( Symbol(), PERIOD_CURRENT, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 1 ) ;
   double MBand   = iMA( Symbol(), PERIOD_CURRENT, 20, 0, MODE_SMA, PRICE_CLOSE, 1 ) ;
   
   Output = NormalizeDouble( ( ( UBand2SD - LBand2SD ) / MBand ) / Point , 2 ) ;
   
   return Output ;
}//end function

int LastBar1 = 0 ;
void EntryAndExit() {
   int ticket = 0 ;
   
   string Signal = "" ;
   Signal = SignalFromMeanReverse() ;
   
   if( LastBar1 != Bars ) {
      
      if( Signal == "Buy" && OrdersTotal() == 0 ) {
         ticket = Buy() ;
         if( LineAlertMode == AlertOn ) {
            LineAlert( LineSDToken, Symbol() + "\n"
               + "MR - BUY\n\n"
               //+ "DD = " + IntegerToString( input_DD_Pts ) + " pts\n"
               //+ "DD bar = " + IntegerToString( input_DD_Bars ) + " bars"
            ) ;
         }//end if
         
         if( ticket != 0 ) {
            OrderCount++ ;
            CurrentOrder = "Buy" ;
            if( TRUE ) {
               DD_Price  = Ask ;
               Max_Price = Ask ;
               SL_Price = LowPrice ;
               sString += Data_1( OrderCount, "Buy", Ask, Digits, LowPrice ) ;
            }//end if
            BarStart = Bars ;
         }//end if
      }//end if
      
      if( Signal == "Sell" && OrdersTotal() == 0 ) {
         ticket = Sell() ;
         if( LineAlertMode == AlertOn ) {
            LineAlert( LineSDToken, Symbol() + "\n"
               + "MR - SELL\n\n"
               //+ "DD = " + IntegerToString( input_DD_Pts ) + " pts\n"
               //+ "DD bar = " + IntegerToString( input_DD_Bars ) + " bars"
            ) ;
         }//end if
         
         if( ticket != 0 ) {
            OrderCount++ ;
            CurrentOrder = "Sell" ;
            if( TRUE ) {
               DD_Price  = Bid ;
               Max_Price = Bid ;
               SL_Price = HighPrice ;
               sString += Data_1( OrderCount, "Sell", Bid, Digits, HighPrice ) ;
            }//end if
            BarStart = Bars ;
         }//end if
      }//end if
   
      if( OrdersTotal() > 0 ) {
         if( Signal == "CloseBuy" && CurrentOrder == "Buy" && OrdersTotal() != 0 ) {
            ticket = CloseAllBuy() ;
            if( ticket != 0 ) {
               sString += Data_2( Bid, Digits ) ;
               CurrentOrder = "" ;
            }//end if
         }//end if
         
         if( Signal == "CloseSell" && CurrentOrder == "Sell" && OrdersTotal() != 0 ) {
            ticket = CloseAllSell() ;
            if( ticket != 0 ) {
               sString += Data_2( Ask, Digits ) ;
               CurrentOrder = "" ;
            }//end if
         }//end if
      }//end if
      
      LastBar1 = Bars ;
   }//end if
   
   if( ExitType == ExitBidAsk )
   if( OrdersTotal() > 0 ) {
         if( Signal == "CloseBuy" && CurrentOrder == "Buy" && OrdersTotal() != 0 ) {
            ticket = CloseAllBuy() ;
            if( ticket != 0 ) {
               sString += Data_2( Bid, Digits ) ;
               CurrentOrder = "" ;
            }//end if
         }//end if
         
         if( Signal == "CloseSell" && CurrentOrder == "Sell" && OrdersTotal() != 0 ) {
            ticket = CloseAllSell() ;
            if( ticket != 0 ) {
               sString += Data_2( Ask, Digits ) ;
               CurrentOrder = "" ;
            }//end if
         }//end if

   }//end if
   
}//end function

//+------------------------------------------------------------------+
double FindHigh( int Bar1, int Bar3 ) {
   double Output = 0 ;
   double Max = -9999999 ;
   double H = 0 ;
   int i = 0 ;

   for( i = 0 ; i < Bar3 - Bar1 ; i++ ) {
      //if( i > Bar4 - Bar3 ) {
         H = iHigh( Symbol(), PERIOD_CURRENT, i ) ;
         if( Max < H ) {
            Max = H ;
         }//end if
         //PrintFormat( "%d ) High = %.5f", i, H ) ;
      //}//end if
   }//end if
   //ExpertRemove() ;
   Output = Max ;
   return Output ;
}//end function

double FindLow( int Bar1, int Bar3 ) {
   double Output = 0 ;
   int i = 0 ;
   double Min = 9999999 ;
   double L = 0 ;

   for( i = 0 ; i < Bar3 - Bar1 ; i++ ) {
      //if( i > Bar4 - Bar3 ) {
         L = iLow( Symbol(), PERIOD_CURRENT, i ) ;
         if( Min > L ) {
            Min = L ;
         }//end if
      //}//end if
   }//end if
   Output = Min ;
   return Output ;
}//end function

int Ords = 1 ;
int Ords_close = 1 ;
void Capture_Open() {
   if( CaltureMode == CaptureOn ) {
      ChartScreenShot( 0, "./Result/" + EA_Name + Symbol() + "_" + IntegerToString( Period() ) + "min_ords_" + IntegerToString( Ords ) + "_1.png", s_width, s_high, ALIGN_RIGHT ) ;
      Ords++ ;
   }//end if
}//end function

void Capture_Close() {
   if( CaltureMode == CaptureOn ) {
      ChartScreenShot( 0, "./Result/" + EA_Name + Symbol() + "_" + IntegerToString( Period() ) + "min_ords_" + IntegerToString( Ords_close ) + "_2.png", s_width, s_high, ALIGN_RIGHT ) ;
      Ords_close++ ;
   }//end if
}//end function

int Buy() {
   int Output = 0 ;
   int i = 0 ;
   C_Price = Order_Price ;
   if( OrdersTotal() == 0 ) {
      Output = OrderSend( Symbol(), OP_BUY, 1.00, Ask, 0, 0, 0, "" ) ;
      Order_Price = Ask ;
      Capture_Open() ;
   }//end if
   if( Output == -1 ) Output = 0 ;
   return Output ;
}//end function

int Sell() {
   int Output = 0 ;
   int i = 0 ;
   C_Price = Order_Price ;
   if( OrdersTotal() == 0 ) {
      Output = OrderSend( Symbol(), OP_SELL, 1.00, Bid, 0, 0, 0, "" ) ;
      Order_Price = Bid ;
      Capture_Open() ;
   }//end if
   if( Output == -1 ) Output = 0 ;
   return Output ;
}//end function


int CloseAllBuy() {
   int i = 0 ;
   int Output = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( OrderSymbol() == Symbol() ) {
            Output = OrderClose( OrderTicket(), OrderLots(), Bid, 0 ) ;
            Capture_Close() ;
            break ;
         }//end if
      }//end if
   }//end if
   return Output ;
}//end function


int CloseAllSell() {
   int i = 0 ;
   int Output = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( OrderSymbol() == Symbol() ) {
            Output = OrderClose( OrderTicket(), OrderLots(), Ask, 0 ) ;
            Capture_Close() ;
            break ;
         }//end if
      }//end if
   }//end if
   return Output ;
}//end function


double LastHigh = 0 ;
double LastLow = 0 ;

datetime bar_t1 ;
datetime bar_t2 ;
datetime bar_t3 ;
datetime bar_t4 ;
datetime bar_t5 ;

double LastHigh1 = 0 ;
double LastLow1 = 0 ;

int BarStart = 0 ;
int BarStop = 0 ;
int OrderCount = 0 ;
double MaxPrice = -9999999 ;
double MinPrice = 9999999 ;

string CurrentOrder = "" ;


string CurrentTime() {
   string Output = "" ;
   int days     = TimeDay( CurrentCountryGMT( +7 ) ) ;
   int months   = TimeMonth( CurrentCountryGMT( +7 ) ) ;
   int years    = TimeYear( CurrentCountryGMT( +7 ) ) + 0 ;
   int Hr       = TimeHour( CurrentCountryGMT( +7 ) ) ;
   int Min      = TimeMinute( CurrentCountryGMT( +7 ) ) ;
   int Sec      = TimeSeconds( CurrentCountryGMT( +7 ) ) ;
   string Date  = IntegerToString( days ) + "/" + IntegerToString( months ) + "/" + IntegerToString( years ) + " " + IntegerToString( Hr ) + ":" + IntegerToString( Min ) + ":" + IntegerToString( Sec ) ;
   return Date ;
}//end function

datetime CurrentCountryGMT( int YourCountryGMTOffset ) {
   int CountyGMTOffset = 3600 * YourCountryGMTOffset;
   return ( CountyGMTOffset + TimeGMT() );
}//end function

string Data_1( int Count, string Order, double Price, int D, double SL_Prices ) {
   string Output = "" ;

   string Days = "" ;
   if( TimeDayOfWeek( TimeCurrent() ) == 0 )       Days = "Sun" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 1 )  Days = "Mon" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 2 )  Days = "Tue" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 3 )  Days = "Wed" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 4 )  Days = "Thu" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 5 )  Days = "Fri" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 6 )  Days = "Sat" ;


   int delay = 1 ;
   double UBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
   double LBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
   double BBP = NormalizeDouble( ( ( Price - LBand2SD ) / ( UBand2SD - LBand2SD ) ) * 100, 2 ) ;

   Output += 
      /* No          */     IntegerToString( Count ) + "\t"
      /* Tactir      */     + "Mean Reverse\t"
      /* Symbol      */     + Symbol() + "\t"
      /* TF          */     + IntegerToString( Period() ) + "\t"
      /* Order       */     + Order + "\t"
      /* Entry Date  */     + CurrentTime() + "\t"
      /* Entry Price */     + DoubleToStr( Price, D ) + "\t"
      /* SL    Price */     + DoubleToStr( 0, D ) + "\t"
      /* Entry BB    */     + DoubleToStr( BBP, 2 ) + "\t"
      /* Entry Day   */     + Days + "\t"
   ;
   
   return Output ;
}//end function

double HighBarPrice( int N = 4 ) {
   double Output = 0 ;
   double Max = -9999999 ;
   for( int i = 0 ; i < N ; i++ ) {
      if( iHigh( Symbol(), PERIOD_CURRENT, i ) > Max ) {
         Max = iHigh( Symbol(), PERIOD_CURRENT, i ) ;
      }//end if
   }//end for
   Output = Max ;
   return Output ;
}//end function

double LowBarPrice( int N = 4 ) {
   double Output = 0 ;
   double Min = 9999999 ;
   for( int i = 0 ; i < N ; i++ ) {
      if( iLow( Symbol(), PERIOD_CURRENT, i ) < Min ) {
         Min = iLow( Symbol(), PERIOD_CURRENT, i ) ;
      }//end if
   }//end for
   Output = Min ;
   return Output ;
}//end function

double SL_Price = 0 ;
string Data_2_Old( double Price, int D ) {
   string Output = "" ;
   string Days = "" ;
   if( TimeDayOfWeek( TimeCurrent() ) == 0 )       Days = "Sun" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 1 )  Days = "Mon" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 2 )  Days = "Tue" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 3 )  Days = "Wed" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 4 )  Days = "Thu" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 5 )  Days = "Fri" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 6 )  Days = "Sat" ;

   double PL = 0 ;
   double SL = Ask ;
   /* Price = Exit Price */
   if( C_Price == 0 ) C_Price = Order_Price ;
   if( CurrentOrder == "Buy" ) {
      PL = Price - Order_Price ;
      //PL = C_Price - Price ;
   } else if( CurrentOrder == "Sell" ) {
      PL = Order_Price - Price ;
      //PL = Price - C_Price ;
   }//end if

   double Highest = HighBarPrice( 4 ) ;
   double Lowest  = LowBarPrice( 4 ) ;
   double p_range = ( Highest - Lowest ) / Point ;
   double n_range = ( ( Highest + p_range * Point ) - ( Lowest - p_range * Point ) ) / Point ;
   
   Output += 
      /* Exit Date             */       IntegerToString( TimeDay( TimeCurrent() ) ) + "/" + IntegerToString( TimeMonth( TimeCurrent() ) ) + "/" + IntegerToString( TimeYear( TimeCurrent() ) ) + "\t"
      /* Exit Time             */     + IntegerToString( TimeHour( TimeCurrent() ) ) + ":" + ( TimeMinute( TimeCurrent() ) <= 10 ? "0" : "" ) + IntegerToString( TimeMinute( TimeCurrent() ) ) + "\t"
      /* Exit Price            */     + DoubleToStr( Price, D ) + "\t"
      /* Exit BBW              */     + DoubleToStr( BBW(), 2 ) + "\t"
      /* PL (pts)              */     + DoubleToStr( PL / Point, 0 ) + "\t"
      /* PL (pts)              */     //+ DoubleToStr( Price, D ) + " - " + DoubleToStr( Order_Price, D ) + "\t"
      /* DD Price              */     + DoubleToStr( DD_Price, D ) + "\t"
      /* Holding Bar           */     + IntegerToString( Bars - BarStart ) + "\t"
      /* Max Profit Price      */     + DoubleToStr( Max_Price, D ) + "\t"
      /* Bars until max Profit */     + IntegerToString( Max_Bar - BarStart <= 0 ? 0 : Max_Bar - BarStart ) + "\t"
      /* Bars until max Profit */     + IntegerToString( DD_Bar - BarStart <= 0 ? 0 : DD_Bar - BarStart ) + "\t"
      /* Day (Number)          */     + IntegerToString( TimeDayOfWeek( TimeCurrent() ) ) + "\t"
      /* Day (String)          */     + Days + "\t"
      /* Highest 4 Bars        */     + DoubleToStr( Highest, D ) + "\t"
      /* Lowest 4 Bars         */     + DoubleToStr( Lowest, D ) + "\t"
      /* previous BEACH Range  */     + DoubleToStr( p_range , 0 ) + "\t"
                                          
      /* Project High 4 Bars   */     + DoubleToStr( Highest + p_range * Point , D ) + "\t"
      /* Project Low  4 Bars   */     + DoubleToStr( Lowest - p_range * Point, D ) + "\t"
      /* Project BEACH Range  */      + DoubleToStr( n_range , 0 ) + "\n"
      
      //+ IntegerToString( Bars - BarStart ) + "\t"
      //+ DoubleToStr( MaxPrice, Digits ) + "\t"
      //+ DoubleToStr( MinPrice, Digits ) + "\n"   ;
   ;
   return Output ;
}//end function

string Data_2( double Price, int D ) {
   string Output = "" ;
   string Days = "" ;
   if( TimeDayOfWeek( TimeCurrent() ) == 0 )       Days = "Sun" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 1 )  Days = "Mon" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 2 )  Days = "Tue" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 3 )  Days = "Wed" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 4 )  Days = "Thu" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 5 )  Days = "Fri" ;
   else if( TimeDayOfWeek( TimeCurrent() ) == 6 )  Days = "Sat" ;

   double PL = 0 ;
   double SL = 0 ;
   double DD_pts = 0 ;
   double Max_pts = 0 ;
      
   /* Price = Exit Price */
   if( CurrentOrder == "Buy" ) {
      PL = Price - Order_Price ;
      SL = 0 ;
   } else if( CurrentOrder == "Sell" ) {
      PL = Order_Price - Price ;
      SL = 0 ;
   }//end if
   DD_pts = MathAbs( DD_Price - C_Price ) ;
   Max_pts = MathAbs( Max_Price - C_Price ) ;

   
   Output += 
      /* Exit Date             */       CurrentTime() + "\t"
      /* Exit Price            */     + DoubleToStr( Price, D ) + "\t"
      /* DD Price              */     + DoubleToStr( DD_Price, D ) + "\t"
      /* Holding Bar           */     + IntegerToString( Bars - BarStart ) + "\t"
      /* Max Profit Price      */     + DoubleToStr( Max_Price, D ) + "\t"
      /* Bars until max Profit */     + IntegerToString( Max_Bar - BarStart ) + "\t"
      /* Bars until max Profit */     + IntegerToString( DD_Bar - BarStart ) + "\t"
      /* Day (Number)          */     + IntegerToString( TimeDayOfWeek( CurrentCountryGMT( +7 ) ) ) + "\t"
      /* Day (String)          */     + Days + "\t"
      /* Win Rate (Profit/SL)  */     + DoubleToStr( 0,0 ) + "\t"
      /*  PL (pts)             */     + DoubleToStr( PL / Point, 0 ) + "\t"
      /*  SL (pts)             */     + DoubleToStr( 0, 0 ) + "\t"
      /*  DD (pts)             */     + DoubleToStr( DD_pts / Point, 0 ) + "\t"
      /*  Max Profit (pts)     */     + DoubleToStr( Max_pts / Point, 0 ) + "\n"
      
      //+ IntegerToString( Bars - BarStart ) + "\t"
      //+ DoubleToStr( MaxPrice, Digits ) + "\t"
      //+ DoubleToStr( MinPrice, Digits ) + "\n"   ;
   ;
   return Output ;
}//end function

double C_Price = 0 ;
int first_case = 0 ;
void MarkSto() {
   int ticket = 0 ;
   string s = "" ;
   int sto_up = StoHigh ;
   int sto_down = StoLow ;

   /**
      Get High
         Low High Low ( 20 80 20 )
      
      Get Low
         High Low High ( 80 20 80 )
   */

   if( LastBar != Bars ) {
      double Sto_main   = iStochastic( Symbol(), PERIOD_CURRENT, 5, 3, 3, MODE_SMA,0,MODE_MAIN, 0 ) ;
      double Sto_signal = iStochastic( Symbol(), PERIOD_CURRENT, 5, 3, 3, MODE_SMA,0,MODE_SIGNAL, 0 ) ;
      
      //----| GET HIGH : Low High Low ( 20 80 20 )
      
      //----| #1 : Mark Red1
      if( step == 1 && Sto_main < sto_down && Sto_signal < sto_down ) {
         DrawLine( "temp_bar_" + IntegerToString( obj ), Salmon ) ;
         obj++ ;                 step = 2 ;     MarkBar1 = Bars ;
         T1 = TimeCurrent() ;    bar_t1 = T1 ;
      }//end if
    
      //----| #2 : Mark Green1
      if( step == 2 && Sto_main > sto_up && Sto_signal > sto_up ) {
         DrawLine( "temp_bar_" + IntegerToString( obj ), Lime ) ;
         obj++ ;                 step = 3 ;     MarkBar2 = Bars ;
         T2 = TimeCurrent() ;    bar_t2 = T2 ;
      }//end if
      
      //----| #3 : Mark Red2
      if( step == 3 && Sto_main < sto_down && Sto_signal < sto_down ) {
         DrawLine( "temp_bar_" + IntegerToString( obj ), Salmon ) ;
         obj++ ;                 step = 4 ;     MarkBar3 = Bars ;
         T3 = TimeCurrent() ;    bar_t3 = T3 ;
         
         HighPrice = FindHigh( MarkBar1, MarkBar3 ) ;
         DrawL( "High", T1, HighPrice, T3, HighPrice ) ;
         DrawTempLine( "h", HighPrice ) ;
         
         if( LineAlertMode == AlertOn ) {
            //LineAlert( LineSDToken, Symbol() + "\n"
            //   + "High Price = " + DoubleToStr( HighPrice, Digits ) + "\n"
            //   + "Low Price = " + DoubleToStr( LowPrice, Digits ) + "\n"
            //) ;
         }//end if
         
      }//end if
      
      //----| #4 : Mark Green2
      if( step == 4 && Sto_main > sto_up && Sto_signal > sto_up ) {
         DrawLine( "temp_bar_" + IntegerToString( obj ), Lime ) ;
         obj++ ;                 step = 2 ;     MarkBar4 = Bars ;
         T4 = TimeCurrent() ;    bar_t4 = T4 ;
         
         LowPrice  = FindLow( MarkBar2, MarkBar4 ) ;
         DrawL( "Low", T2, LowPrice, T4, LowPrice ) ;
         DrawTempLine( "l", LowPrice ) ;
         
         if( LineAlertMode == AlertOn ) {
            LineAlert( LineSDToken, Symbol() + "\n"
               + "High Price = " + DoubleToStr( HighPrice, Digits ) + "\n"
               + "Low Price = " + DoubleToStr( LowPrice, Digits ) + "\n"
            ) ;
         }//end if
         
         
         T1 = T3 ;
         T2 = T4 ;
         
         MarkBar1 = MarkBar3 ;
         MarkBar2 = MarkBar4 ;
     }//end if
      
      //----| Comment
      s += "Step = " + IntegerToString( step ) + "\n" ;
      s += "High = " + DoubleToStr( HighPrice, Digits ) + "\n" ;
      s += "Low = " + DoubleToStr( LowPrice, Digits ) + "\n" ;
      //Comment( s ) ;
      
      
      LastBar = Bars ;
   }//end if
}//end function

int l_obj = 0 ;
void DrawL( string obj_name, datetime t1, double p1, datetime t2, double p2 ) {
   ObjectCreate( obj_name + IntegerToString( l_obj ), OBJ_TREND, 0, t1, p1, t2, p2 ) ;
   ObjectSet(    obj_name + IntegerToString( l_obj ), OBJPROP_COLOR, White );          //Color of this Object
   ObjectSet(    obj_name + IntegerToString( l_obj ), OBJPROP_STYLE, STYLE_SOLID );    //Set Line to Solid
   ObjectSet(    obj_name + IntegerToString( l_obj ), OBJPROP_WIDTH, 1 );              //Set Width of Line
   ObjectSet(    obj_name + IntegerToString( l_obj ), OBJPROP_RAY_RIGHT, FALSE );      //Set Ray
   l_obj++ ;
}//end function

void DrawTempLine( string obj_name, double TargetPrice )  {
   ObjectCreate(  obj_name + "_t_l", OBJ_HLINE, 0, 0, 0 );            //Declare HLine Object
   ObjectSet(     obj_name + "_t_l", OBJPROP_COLOR, Pink );              //Color of this Object
   ObjectSet(     obj_name + "_t_l", OBJPROP_STYLE, STYLE_DASH );    //Set Line to Solid
   ObjectSet(     obj_name + "_t_l", OBJPROP_WIDTH, 1 );              //Set Width of Line
   ObjectSet(     obj_name + "_t_l", OBJPROP_PRICE1, TargetPrice );   // Move
}//end function

bool LineAlert( string Token, string Message ) {
   bool Output = FALSE ;
   
   string headers;
   char data[], result[];
   headers = "Authorization: Bearer "+Token+"\r\n	application/x-www-form-urlencoded\r\n";
   ArrayResize(data,StringToCharArray("message="+Message,data,0,WHOLE_ARRAY,CP_UTF8)-1);

   int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 0, data, data, headers);
   
   //PrintFormat( "res = %d", res ) ;
   if( res == -1 ) { 
      Print("Error in WebRequest. Error code  =",GetLastError()); 
      Print("Add the address 'https://notify-api.line.me/api/notify' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION); 
   } else {
      Output = TRUE ;
   } //end if

   return Output ;
}//end function



string   sFileName, sString;
int      iHandle, iErrorCode, iInteger, iDecimalPlaces;
double   dDouble;

bool fnReadFile() {
   iHandle = FileOpen(sFileName,FILE_CSV|FILE_READ);
   if(iHandle < 1) {
      iErrorCode = GetLastError();
      if (iErrorCode == 4103) Print("File not found");
      else                    Print("Error reading file: ",iErrorCode);
      return(false);
   }//end if
   iInteger  = StrToInteger(FileReadString(iHandle));
   sString   = FileReadString(iHandle);
   dDouble   = StrToDouble(FileReadString(iHandle)); 
   FileClose(iHandle);
   return(true);  
}//function

bool fnWriteFile() {
   iHandle = FileOpen(sFileName,FILE_CSV|FILE_WRITE);
   if(iHandle < 1) {
      iErrorCode = GetLastError();
      Print("Error updating file: ",iErrorCode);
      return(false);
   }
   //FileWrite(iHandle,iInteger,sString,DoubleToStr(dDouble,iDecimalPlaces));
   FileWrite( iHandle , sString );
   FileClose(iHandle);
   return(true);
 }//function

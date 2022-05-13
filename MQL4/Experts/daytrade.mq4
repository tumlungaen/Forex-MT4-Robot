//+------------------------------------------------------------------+
//|                                                     daytrade.mq4 |
//|                              Copyright 2022, Thailand Fx Warrior |
//|                                https://www.thailandfxwarrior.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Thailand Fx Warrior"
#property link      "https://www.thailandfxwarrior.com"
#property version   "1.00"
#property strict

string EA_Name  = "BO_" ;

enum PendingEnum {
   PendingOff ,   //Off
   PendingOn  ,   //On
} ;

enum EntryOrderEnum {
   EntryOff ,  //Off
   EntryOn  ,  //On
} ;



 string x1 = "====| L I N E    A P I |====" ;    //-----------------------------------------
 string LineSDToken   = "";
//input string LineSDToken   = "eKZtrVCOiAuaq8Vr8BPAUVVXUTDWWj1dX2BmwfKobNB";
 int    input_DD_Pts  = 0 ;  //Drawdown (pts)
 int    input_DD_Bars = 0 ;  //Drawdown (bars)

 int StoHigh = 80 ;   // Sto High (%)
 int StoLow  = 20 ;   // Sto Low (%)

input double Lot = 0.01 ;  // Lot
input string cmmt = "Daytrade" ; //Comment
input int    magicnumber = 101 ; //Magic Number

enum ReverseEnum {
   ReverseOff , //Off
   ReverseOn  , //On
} ;
input ReverseEnum ReverseMode = ReverseOff ; //Reverse BO Mode

enum MatingaleEnum {
   MartingaleOff , //Off
   MartingaleOn  , //On
} ;
input MatingaleEnum MartingaleMode = MartingaleOff ; //Martingale Mode
input double Multiply = 1.2 ; // Multiply in Martingale Mode

enum AutoTPEnum {
   AutoTPOff  ,    // Trailing Stop
   AutoTPSL   ,    // TP/SL
   AutoTPFibo ,    // Fibonacci Level
} ;
 string k0 = "---| TP Setting" ; //---| TP Setting
 AutoTPEnum AutoTPMode = AutoTPSL ; //Auto TP Mode

input string k1 = "---| Mode : RR Setting" ; //---| Mode : TP/SL Setting
 int tp_point = 0 ; //TP (pts)
 int sl_point = 0 ; //SL (pts)
input double RR = 2 ; //RRR (Input Reward)
 string k2 = "---| Mode : Fibonacci Setting" ; //---| Mode : Fibonacci Setting
 double fibo_tp_level = 161.8 ; //Fibo Lv TP

enum AutoLotEnum {
   AutoLotOff ,   //Off
   AutoLotOn  ,   //On
} ;
input string k3 = "----| Auto Lot Mode" ; //----| Auto Lot Mode
input AutoLotEnum AutoLotMode = AutoLotOff ; //Auto Lot Mode
input double PercentBalance = 20 ; //Percentage of Balance (%)

input string xx0 = "====| Pending Order |====" ; //----| Pending Order
 EntryOrderEnum EntryMode = EntryOn ;   //Entry Order ( Off/On )
input PendingEnum PendingMode = PendingOff ; //Pending Mode
input double Retracement      = 61.8 ;       //Retracement (%)
input int         ExpHr       = 4 ;          //Exp Hr

input string k4 = "----| Risk Parameter" ; //----| Risk Parameter
enum RP_enum {
   RP_Off , //Off
   RP_On  , //On
} ;
input RP_enum RP_Mode = RP_Off ; //RP Mode (Off/On)

input string k5 = "----| Special Setting" ; //----| Special Setting
input int    MaxSLPoint  = 250 ; //Max SL Points (0=Off)
input int    StartHr     = 18 ;  //Start Entry Hour (-1=Off)
input int    StopHr      = 23 ;   //Stop  Entry Hour (-1=Off)

 string x4 = "====| Allow Weekday Trade (Start to Stop) |====" ;    //-----------------------------------------

 int mon_start_hr = 0 ; //--| Mon Start Hr
 int mon_stop_hr  = 0 ; //--| Mon Stop Hr

 int tue_start_hr = 0 ; //Tue Start Hr
 int tue_stop_hr  = 0 ; //Tue Stop Hr

 int wed_start_hr = 0 ; //--| Wed Start Hr
 int wed_stop_hr  = 0 ; //--| Wed Stop Hr

 int thu_start_hr = 0 ; //Thu Start Hr
 int thu_stop_hr  = 0 ; //Thu Stop Hr

 int fri_start_hr = 0 ; //--| Fri Start Hr
 int fri_stop_hr  = 0 ; //--| Fri Stop Hr
 

 string MTradingTimeSet = "" ;    //Mon
 string TTradingTimeSet = "" ;    //Tue
 string WTradingTimeSet = "" ;    //Wed
 string ThTradingTimeSet = "" ;   //Thu
 string FTradingTimeSet = "" ;    //Fri


 string x3 = "====| F I L E |====" ;    //-----------------------------------------
 string      f_input     = "trading_record";              // ----| File Name

enum HeaderEnum {
   HeaderOff ,    //Off
   HeaderOn  ,    //On
} ;
 HeaderEnum HeaderMode = HeaderOn ; //Header Mode (On/Off)

string FileName = Symbol() + "_" + f_input + "_" + IntegerToString( Period() ) + "min" + ".csv" ;

enum LineAlertEnum {
   AlertOff ,  //Off
   AlertOn  ,  //On
} ;
 LineAlertEnum LineAlertMode = AlertOff ;  // Line Alert Mode (On/Off)

enum CaptureEnum {
   CaptureOff ,   //Off
   CaptureOn  ,   //On
} ;
 CaptureEnum CaltureMode = CaptureOff ;    //Capture Mode (On/Off)


enum DrawLineEnum {
   DrawOff ,   //Off
   DrawOn  ,   //On
} ;
 DrawLineEnum DrawMode = DrawOff ;         //

int OnInit() {
   SpeedMarkSto() ;
   return( INIT_SUCCEEDED );
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
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
      ObjectSet(     EA_Names + "Line", OBJPROP_TIME, TimeCurrent() ) ;
      //ObjectSet(     EA_Names + "Line", OBJPROP_PRICE1, TargetPrice );   // Move
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

double CalculateAllLot( double PercentageBalance ) {
   double Output = 0 ;
   Output = ( AccountLeverage() * AccountBalance() ) / ( SymbolInfoDouble( Symbol(), SYMBOL_TRADE_CONTRACT_SIZE ) * Bid ) ;
   Output = Output * PercentageBalance / 100 ;
   if( Output <= MarketInfo( Symbol(), MODE_MINLOT ) ) Output = MarketInfo( Symbol(), MODE_MINLOT ) ;
   if( Output >= MarketInfo( Symbol(), MODE_MAXLOT ) ) Output = MarketInfo( Symbol(), MODE_MAXLOT ) ;
   return Output ;
}//end function

int step = 1 ;
int LastBar_x = 0 ;
void OnTick() {
   SpeedMarkSto() ;
   EntryAndExit() ;
}//end function

void SplitTimeRange( string &TimeRangeSet[], string TimeRangeString, string Split = "-" )  {
   ushort u_sep;
   int    k;
   u_sep = StringGetCharacter( Split , 0 );
   k     = StringSplit( TimeRangeString , u_sep , TimeRangeSet );
}//end function

void SplitTime( string &TimeSet[], string TimeString, string Split = "," )  {
   ushort u_sep;
   int    k;
   u_sep = StringGetCharacter( Split , 0 );
   k     = StringSplit( TimeString , u_sep , TimeSet );
}//end function


bool TimeHandling() {
   bool     Output      = FALSE;
   int      TodayDate   = TimeDayOfWeek( CurrentCountryGMT( 7 ) );
   int      CurrentHour = TimeHour(   CurrentCountryGMT( 7 ) );
   int      CurrentMin  = TimeMinute( CurrentCountryGMT( 7 ) );
   datetime CurrentTime = StringToTime( IntegerToString( CurrentHour ) + ":" + IntegerToString( CurrentMin ) );
   int      i           = 0;
   int      j           = 0;
   int      k           = 0;
   string   s           = "";
   string   TimeSet[];
   //string   TimeRange[];
   
   string   TimeStringSet = "";
   
   if( TodayDate == 1 )      TimeStringSet = MTradingTimeSet;
   else if( TodayDate == 2 ) TimeStringSet = TTradingTimeSet;
   else if( TodayDate == 3 ) TimeStringSet = WTradingTimeSet;
   else if( TodayDate == 4 ) TimeStringSet = ThTradingTimeSet;
   else if( TodayDate == 5 ) TimeStringSet = FTradingTimeSet;
   
      if( TimeStringSet != "" ) {
         SplitTime( TimeSet, TimeStringSet ) ;
         //for( i = 0 ; i < ArraySize( TimeSet ) ; i++ ) {
         //   SplitTimeRange( TimeRange, TimeSet[ i ] );
         //   if( CurrentTime > StrToTime( TimeRange[ 0 ] + ":00" ) && CurrentTime < StrToTime( TimeRange[ 1 ] ) ) {
         //      Output = TRUE;
         //      break;
         //   } else {
         //      Output = FALSE;
         //   }
         //}//end for i
         //--------------------------------
         for( i = 0 ; i < ArraySize( TimeSet ) ; i++ ) {
            if( CurrentTime > StrToTime( TimeSet[ i ] + ":00" ) && CurrentTime < StrToTime( TimeSet[ i ] + ":59" ) ) {
               Output = TRUE;
               //PrintFormat( "====| %d | %s, [ %s to %s ]", TodayDate, TimeSet[i], TimeToStr( StrToTime( TimeSet[ i ] + ":00" ) ), TimeToStr( StrToTime( TimeSet[ i ] + ":59" ) ) ) ;
               break;
            } else {
               Output = FALSE;
            }
         }//end for i
         //--------------------------------
      } else {
         Output = FALSE;
      }//end if

   if( TodayDate == 1 && TimeHour( CurrentCountryGMT( 7 ) ) < 7 ) {
      Output = FALSE ;
   }//end if
   
   if( TodayDate == 6 && TimeHour( CurrentCountryGMT( 7 ) ) >= 3 ) {
      Output = FALSE ;
   }//end if

   if( MTradingTimeSet == "" && TTradingTimeSet == "" && WTradingTimeSet == "" && ThTradingTimeSet == "" && FTradingTimeSet == "" ) {
      Output = TRUE ;
   }//end if

   return Output;
}//end function

bool AllowDateTrade() {
   bool Output = FALSE ;
   int Hr = TimeHour( CurrentCountryGMT( +7 ) ) ;
   
   if( TimeDayOfWeek( CurrentCountryGMT( +7 ) ) == 1 ) if( Hr >= mon_start_hr && Hr <= mon_stop_hr && ( mon_start_hr != 0 && mon_stop_hr != 0 ) ) Output = TRUE ;
   if( TimeDayOfWeek( CurrentCountryGMT( +7 ) ) == 2 ) if( Hr >= tue_start_hr && Hr <= tue_stop_hr && ( tue_start_hr != 0 && tue_stop_hr != 0 ) ) Output = TRUE ;
   if( TimeDayOfWeek( CurrentCountryGMT( +7 ) ) == 3 ) if( Hr >= wed_start_hr && Hr <= wed_stop_hr && ( wed_start_hr != 0 && wed_stop_hr != 0 ) ) Output = TRUE ;
   if( TimeDayOfWeek( CurrentCountryGMT( +7 ) ) == 4 ) if( Hr >= thu_start_hr && Hr <= thu_stop_hr && ( thu_start_hr != 0 && thu_stop_hr != 0 ) ) Output = TRUE ;
   if( TimeDayOfWeek( CurrentCountryGMT( +7 ) ) == 5 ) if( Hr >= fri_start_hr && Hr <= fri_stop_hr && ( fri_start_hr != 0 && fri_stop_hr != 0 ) ) Output = TRUE ;

   if( mon_start_hr == 0 && mon_stop_hr == 0 && tue_start_hr == 0 && tue_stop_hr == 0 && wed_start_hr == 0 && wed_stop_hr == 0 && thu_start_hr == 0 && thu_stop_hr == 0 && fri_start_hr == 0 && fri_stop_hr == 0 ) {
      Output = TRUE ;
   }//end if

   return Output ;
}//end function

datetime T1_High ;
datetime T2_High ;
datetime T1_Low ;
datetime T2_Low ;

double SpeedFindHighPrice( ENUM_TIMEFRAMES TF_Input = PERIOD_D1, int delay = 1 ) {
   double Output = 0 ;
   int N_Bar = 500 ;
   int iiii = 0 ;
   double C = 0, real_Price = 0 ;
   int event = 0 ;
   
   bool GoldenCross   = FALSE ;
   bool DeathCross = FALSE ;
   
   double MA1 = 0, MA2 = 0, Last_MA1 = 0, Last_MA2 = 0, Last_C = 0 ;
   double Max = -9999999 ;
      
   for( iiii = 0 ; iiii < N_Bar ; iiii++ ) {
      C = iClose( Symbol(), TF_Input, iiii + 1 ) ;
      real_Price = iHigh( Symbol(), TF_Input, iiii + 1 ) ;

      MA1   = iMA( Symbol(), TF_Input, 30, 0, MODE_SMA, PRICE_HIGH, iiii + 1 ) ;
      MA2 = iMA( Symbol(), TF_Input, 30, 0, MODE_SMA, PRICE_LOW, iiii + 1 ) ;
      Last_C = iClose( Symbol(), TF_Input, iiii + 2 ) ;
      Last_MA1 = iMA( Symbol(), TF_Input, 30, 0, MODE_SMA, PRICE_HIGH, iiii + 2 ) ;
      Last_MA2 = iMA( Symbol(), TF_Input, 30, 0, MODE_SMA, PRICE_LOW, iiii + 2 ) ;

      GoldenCross = C >= MA1 && Last_C < Last_MA1 ;
      DeathCross  = C <= MA2 && Last_C > Last_MA2 ;
      
      if( DeathCross && event == 0 )  event = 1 ;
      if( GoldenCross && event == 1 ) event = 2 ;
      if( DeathCross && event == 2 )  event = 3 ;
      if( GoldenCross && event == 3 ) event = 4 ;
      
      if( event > 0 && Max < real_Price ) {
         Max = real_Price ;
         if( delay == 1 ) T1_High = iTime( Symbol(), TF_Input, iiii + 1 ) ;
         if( delay == 2 ) T2_High = iTime( Symbol(), TF_Input, iiii + 1 ) ;
      }//end if
      
      if( delay == 1 && event == 2 ) break ;
      if( delay == 2 && event == 4 ) break ;
      
      if( event == 2 ) Max = -9999999 ;
      
   }//end for
   Output = Max ;
   return Output ;
}//end function

double SpeedFindLowPrice( ENUM_TIMEFRAMES TF_Input = PERIOD_D1, int delay = 1 ) {
   double Output = 0 ;
   int N_Bar = 500 ;
   int iiii = 0 ;
   double C = 0, real_Price = 0 ;
   int event = 0 ;
   
   bool GoldenCross   = FALSE ;
   bool DeathCross = FALSE ;
   
   double MA1 = 0, MA2 = 0, Last_MA1 = 0, Last_MA2 = 0, Last_C = 0 ;
   double Min = 9999999 ;
      
   for( iiii = 0 ; iiii < N_Bar ; iiii++ ) {
      C = iClose( Symbol(), TF_Input, iiii + 1 ) ;
      real_Price = iLow( Symbol(), TF_Input, iiii + 1 ) ;

      MA1   = iMA( Symbol(), TF_Input, 30, 0, MODE_SMA, PRICE_HIGH, iiii + 1 ) ;
      MA2 = iMA( Symbol(), TF_Input, 30, 0, MODE_SMA, PRICE_LOW, iiii + 1 ) ;
      Last_C = iClose( Symbol(), TF_Input, iiii + 2 ) ;
      Last_MA1 = iMA( Symbol(), TF_Input, 30, 0, MODE_SMA, PRICE_HIGH, iiii + 2 ) ;
      Last_MA2 = iMA( Symbol(), TF_Input, 30, 0, MODE_SMA, PRICE_LOW, iiii + 2 ) ;

      GoldenCross = C >= MA1 && Last_C < Last_MA1 ;
      DeathCross  = C <= MA2 && Last_C > Last_MA2 ;
      
      if( GoldenCross && event == 0 )  event = 1 ;
      if( DeathCross && event == 1 )   event = 2 ;
      if( GoldenCross && event == 2 )  event = 3 ;
      if( DeathCross && event == 3 )   event = 4 ;
      
      if( event > 0 && Min > real_Price ) {
         Min = real_Price ;
         if( delay == 1 ) T1_Low = iTime( Symbol(), TF_Input, iiii + 1 ) ;
         if( delay == 2 ) T2_Low = iTime( Symbol(), TF_Input, iiii + 1 ) ;
      }//end if
      
      if( delay == 1 && event == 2 ) break ;
      if( delay == 2 && event == 4 ) break ;
      
      if( event == 2 ) Min = 9999999 ;
      
      
   }//end for
   Output = Min ;
   return Output ;
}//end function

double HHH = -9999999 ;
double LLL = 0 ;
void FindRiskParameter() {
   int i = 0 ;
   double Sum_B = 0 ;
   double Sum_S = 0 ;
   double C = 0 ;
   for( i = 0 ; i <= 20 ; i++ ) {
      C = iClose( Symbol(), PERIOD_D1, i ) ;
      if( C > HHH ) HHH = C ;
      if( C < LLL ) LLL = C ;
   }//end for
}//end function

double Avg_Buy = 0 ;
double Avg_Sell = 0 ;
void FindRiskParameter_Backup() {

   int i = 0 ;
   double Sum_Buy = 0 ;
   double Sum_Sell = 0 ;
   int count_Buy = 0 ;
   int count_Sell = 0 ;
   
   //if( LastBar != Bars ) {
      
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
      else Avg_Buy = 0 ;
      
      if( count_Sell > 0 ) Avg_Sell = Sum_Sell / count_Sell ;
      else Avg_Sell = 0 ;
      
//      DrawLine( Avg_Buy, "B", ForestGreen ) ;
//      DrawLine( Avg_Sell, "S", Salmon ) ;
//      
//      DrawText( "B", "Average Cost: Buy @" + DoubleToStr( Avg_Buy, Digits ) , 9, Avg_Buy , ForestGreen ) ;
//      DrawText( "S", "Average Cost: Sell @" + DoubleToStr( Avg_Sell, Digits ), 9, Avg_Sell, Salmon ) ;
//      
      //LastBar = Bars ;
   //}//end if
}//end function

double HighPrice2 = 0 ;
double LowPrice2  = 0 ;

double H_Current = 0 ;
double L_Current = 0 ;

void SpeedMarkSto() {

   bool Condition = FALSE ;
   if( EntryMode == EntryOn ) Condition = LastBar != Bars ;
   else                       Condition = TRUE ;
   
   if( Condition ) {
   
      H_Current = SpeedFindHighPrice( PERIOD_CURRENT, 1 ) ;
      L_Current  = SpeedFindLowPrice( PERIOD_CURRENT, 1 ) ;
   
      HighPrice = SpeedFindHighPrice( PERIOD_H1, 1 ) ;
      LowPrice  = SpeedFindLowPrice( PERIOD_H1, 1 ) ;
   
      HighPrice2 = SpeedFindHighPrice( PERIOD_H1, 2 ) ;
      LowPrice2  = SpeedFindLowPrice( PERIOD_H1, 2 ) ;
      LastBar = Bars ;
   }//end if
}//end function

int LastBar1 = 0 ;
void EntryAndExit() {
   int ticket = 0 ;
   double Variable_Lot = 0.01 ;
   
   int HR = TimeHour( CurrentCountryGMT( +7 ) ) ;
   bool isHrEnable = TRUE ;
   if( StartHr != -1 && StopHr != -1 ) {
      isHrEnable = HR >= StartHr && HR <= StopHr ;
   }//end if
   
   if( LastBar1 != Bars ) {
      
      //-------| ENTRY & EXIT
      if( HighPrice != -9999999 || LowPrice != 9999999 ) {
      
         //----| Set close price to variable
         Variable_Lot = Lot ;
         if( AutoLotMode == AutoLotOn ) Variable_Lot = CalculateAllLot( PercentBalance ) ;
         
         double C = iClose( Symbol(), PERIOD_CURRENT, 1 ) ;
         double MA1 = iMA( Symbol(), PERIOD_CURRENT, 30, 0, MODE_SMA, PRICE_HIGH, 1 ) ;
         double MA2 = iMA( Symbol(), PERIOD_CURRENT, 30, 0, MODE_SMA, PRICE_LOW, 1 ) ;
         double Last_C = iClose( Symbol(), PERIOD_CURRENT, 2 ) ;
         double Last_MA1 = iMA( Symbol(), PERIOD_CURRENT, 30, 0, MODE_SMA, PRICE_HIGH, 2 ) ;
         double Last_MA2 = iMA( Symbol(), PERIOD_CURRENT, 30, 0, MODE_SMA, PRICE_LOW, 2 ) ;
         
         double MACD_Main = iMACD( Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1 ) ;
   
         bool GoldenCross = C >= MA1 && Last_C < Last_MA1 && MACD_Main > 0 ;
         bool DeathCross  = C <= MA2 && Last_C > Last_MA2 && MACD_Main < 0 ;
         
         bool isUpTrend   = HighPrice > HighPrice2 && LowPrice > LowPrice2 ;
         bool isDownTrend = HighPrice < HighPrice2 && LowPrice < LowPrice2 ;
         
         bool RP_Logic_Buy  = TRUE ;
         bool RP_Logic_Sell = TRUE ;
         if( RP_Mode == RP_On ) {
            FindRiskParameter() ;
            RP_Logic_Buy  = Bid < HHH ;
            RP_Logic_Sell = Ask > LLL ;
         }//end if
         
         bool sl_condition_buy  = TRUE ;
         bool sl_condition_sell = TRUE ;
         if( MaxSLPoint > 0 ) {
            sl_condition_buy  = NormalizeDouble( ( Bid - L_Current ) / Point, 0 ) <= MaxSLPoint ;
            sl_condition_sell = NormalizeDouble( ( H_Current - Ask ) / Point, 0 ) <= MaxSLPoint ;
         }//end if
         
         //----| Entry Buy : Active
         if( GoldenCross && isUpTrend && RP_Logic_Buy && sl_condition_buy && isHrEnable ) {
            if( RP_Mode == RP_On ) FindRiskParameter() ;
            if( ReverseMode == ReverseOff ) {
               //CloseAllSell() ;

               if( MartingaleMode == MartingaleOff ) ticket = Buy( Variable_Lot ) ;
               else {
                  if( isLoss_LastOrderResult() ) ticket = Buy( Lot_LastOrderResult() * Multiply ) ;
                  else ticket = Buy( Variable_Lot ) ;
               }//end if
               
            } else {
               //CloseAllBuy() ; 
               if( MartingaleMode == MartingaleOff ) ticket = Sell( Variable_Lot ) ;
               else {
                  if( isLoss_LastOrderResult() ) ticket = Sell( Lot_LastOrderResult() * 2 ) ;
                  else ticket = Sell( Variable_Lot ) ;
               }//end if
            }//end if
            if( LastHigh != HighPrice && HighPrice != -9999999 ) LastHigh = HighPrice ;
         } else if( DeathCross && isDownTrend && RP_Logic_Sell && sl_condition_sell && isHrEnable ) {
            if( RP_Mode == RP_On ) FindRiskParameter() ;
            
            if( ReverseMode == ReverseOff ) {
               //CloseAllBuy() ;
               if( MartingaleMode == MartingaleOff ) ticket = Sell( Variable_Lot ) ;
               else {
                  if( isLoss_LastOrderResult() ) ticket = Sell( Lot_LastOrderResult() * 2 ) ;
                  else ticket = Sell( Variable_Lot ) ;
               }//end if
            } else {
               //CloseAllSell() ;
               if( MartingaleMode == MartingaleOff ) ticket = Buy( Variable_Lot ) ;
               else {
                  if( isLoss_LastOrderResult() ) ticket = Buy( Lot_LastOrderResult() * 2 ) ;
                  else ticket = Buy( Variable_Lot ) ;
               }//end if
            }//end if
            if( LastLow != LowPrice ) LastLow = LowPrice ;
         }//end if
      }//end if
      
      LastBar1 = Bars ;
   }//end if
}//end function

double Lot_LastOrderResult() {
   double Output = MarketInfo( Symbol(), MODE_MINLOT ) ;
   for( int i = OrdersHistoryTotal() - 1 ; i > 0 ; i--  ) {
      if( OrderSelect( OrdersHistoryTotal() - 1, SELECT_BY_POS, MODE_HISTORY ) ) {
         if( OrderMagicNumber() == magicnumber && OrderSymbol() == Symbol() ) {
            Output = OrderLots() ;
            //PrintFormat( "%d) %d %.2f", OrderTicket(), OrderType(), OrderLots() ) ;
            break ;
         }//end if
      }//end if
   }//end for
   if( Output > MarketInfo( Symbol(), MODE_MAXLOT ) ) Output = MarketInfo( Symbol(), MODE_MAXLOT ) ;
   return Output ;
}//end if

bool isLoss_LastOrderResult() {
   bool Output = FALSE ;
   for( int i = OrdersHistoryTotal() - 1 ; i > 0 ; i--  ) {
      if( OrderSelect( OrdersHistoryTotal() - 1, SELECT_BY_POS, MODE_HISTORY ) ) {
         if( OrderMagicNumber() == magicnumber && OrderSymbol() == Symbol() && OrderProfit() + OrderCommission() + OrderSwap() < 0 ) {
            Output = TRUE ;
            break ;
         }//end if
      }//end if
   }//end for
   return Output ;
}//end if

//+------------------------------------------------------------------+
double FindHigh( int Bar1, int Bar3 ) {
   double Output = 0 ;
   double Max = -9999999 ;
   double H = 0 ;
   int i = 0 ;

   for( i = 0 ; i < Bar3 + diff - Bar1 ; i++ ) {
      //if( i > Bar4 - Bar3 ) {
         H = iClose( Symbol(), PERIOD_CURRENT, i ) ;
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

   for( i = 0 ; i < Bar3 + diff - Bar1 ; i++ ) {
      //if( i > Bar4 - Bar3 ) {
         L = iClose( Symbol(), PERIOD_CURRENT, i ) ;
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
      ChartScreenShot( 0, "./Result/" + EA_Name + Symbol() + "_" + IntegerToString( Period() ) + "min_ords_" + IntegerToString( Ords ) + "_1.png", 1500, 550, ALIGN_RIGHT ) ;
      Ords++ ;
   }//end if
}//end function

void Capture_Close() {
   if( CaltureMode == CaptureOn ) {
      ChartScreenShot( 0, "./Result/" + EA_Name + Symbol() + "_" + IntegerToString( Period() ) + "min_ords_" + IntegerToString( Ords_close ) + "_2.png", 1500, 550, ALIGN_RIGHT ) ;
      Ords_close++ ;
   }//end if
}//end function

int last_ords = -1 ;
int Buy( double Input_Lot ) {
   int Output = 0 ;
   int i = 0 ;
   C_Price = Order_Price ;
   
   int range_sl = (int)NormalizeDouble( ( Ask - L_Current ) / Point, 0 ) ;
   
   double TP_Price = 0 ;
   double SL_Price = 0 ;
   if( AutoTPMode == AutoTPSL ) {
      TP_Price = Ask + range_sl * RR * Point ;
      SL_Price = Ask - range_sl * Point ;
   } else if( AutoTPMode == AutoTPFibo ) {
      TP_Price = HighPrice + ( HighPrice - LowPrice ) * (fibo_tp_level/100) ;
   } else {
      TP_Price = 0 ; SL_Price = 0 ;
   }//end if
   double range = 0 ;
   
   double Lots = Input_Lot ;
   
   if( OrdersTotal() == 0 ) {
   //if( TRUE ) {
      if( PendingMode == PendingOff ) Output = OrderSend( Symbol(), OP_BUY, Lots, NormalizeDouble( Ask, Digits ), 3, NormalizeDouble( SL_Price, Digits ), NormalizeDouble( TP_Price, Digits ), cmmt + "-" + IntegerToString( magicnumber ), magicnumber ) ;
      else {
         double SLs = L_Current ;
         double PendingPrice = L_Current + ( H_Current - L_Current ) * (Retracement/100) ;
         double TargetPrice  = ( PendingPrice - SLs ) * RR + PendingPrice ;
         datetime ExpDate    = TimeCurrent() + ( 60 * 60 * ExpHr ) ;
         Output = OrderSend( Symbol(), OP_BUYLIMIT, Lots, NormalizeDouble( PendingPrice, Digits ), 3, NormalizeDouble( SLs, Digits ), NormalizeDouble( TargetPrice, Digits ), cmmt + "-" + IntegerToString( magicnumber ), magicnumber, ExpDate ) ;
         if( Output == -1 ) Output = OrderSend( Symbol(), OP_BUYSTOP, Lots, NormalizeDouble( PendingPrice, Digits ), 3, NormalizeDouble( LowPrice, Digits ), NormalizeDouble( TargetPrice, Digits ), cmmt + "-" + IntegerToString( magicnumber ), magicnumber, ExpDate ) ;
         //CurrentOrder = "Buy" ;
      }//end if
   }//end if
   if( Output == -1 ) Output = 0 ;
   return Output ;
}//end function

int Sell( double Input_Lot ) {
   int Output = 0 ;
   int i = 0 ;
   C_Price = Order_Price ;
   
   int range_sl = (int)NormalizeDouble( ( H_Current - Bid ) / Point, 0 ) ;
   
   double TP_Price = 0 ;
   double SL_Price = 0 ;
   //if( tp_point > 0 ) TP_Price = Bid - tp_point * Point ;
   //if( sl_point > 0 ) SL_Price = Bid + tp_point * Point ;
   
   TP_Price = Bid - range_sl * RR * Point ;
   SL_Price = Bid + range_sl * Point ;
   
   double Lots = Input_Lot ;

   if( OrdersTotal() == 0 ) {
   //if( TRUE ) {
      if( PendingMode == PendingOff ) Output = OrderSend( Symbol(), OP_SELL, Lots, NormalizeDouble( Bid, Digits ), 3, NormalizeDouble( SL_Price, Digits ), NormalizeDouble( TP_Price, Digits ), cmmt + "-" + IntegerToString( magicnumber ), magicnumber ) ;
      else {
         double TargetPrice  = L_Current - ( H_Current - L_Current ) * 1.236 ;
         double PendingPrice = H_Current - ( H_Current - L_Current ) * (Retracement/100) ;
         datetime ExpDate    = TimeCurrent() + ( 60 * 60 * ExpHr ) ;
         double SLs = H_Current ; //HighPrice ;
         Output = OrderSend( Symbol(), OP_SELLLIMIT, Lots, NormalizeDouble( PendingPrice, Digits ), 3, NormalizeDouble( SLs, Digits ), NormalizeDouble( TargetPrice, Digits ), cmmt + "-" + IntegerToString( magicnumber ), magicnumber, ExpDate ) ;
         if( Output == -1 ) Output = OrderSend( Symbol(), OP_SELLSTOP, Lots, NormalizeDouble( PendingPrice, Digits ), 3, NormalizeDouble( HighPrice, Digits ), NormalizeDouble( TargetPrice, Digits ), cmmt + "-" + IntegerToString( magicnumber ), magicnumber, ExpDate ) ;
      }//end if
      Order_Price = Bid ;
   }//end if
   if( Output == -1 ) Output = 0 ;
   return Output ;
}//end function


int CloseAllBuy() {
   int i = 0 ;
   int Output = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( OrderSymbol() == Symbol() && magicnumber == OrderMagicNumber() && OrderType() == OP_BUY ) {
            Output = OrderClose( OrderTicket(), OrderLots(), Bid, 3 ) ;
            
            //PrintFormat( "--| Close by [ %s ] Magic Number = %d, TF = %dM Close Buy", Symbol(), magicnumber, Period() ) ;
            //SendNotification( "Close Buy : " + Symbol() + ", MG : " + IntegerToString( magicnumber ) + ", TF: " + IntegerToString( Period() ) ) ;
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
         if( OrderSymbol() == Symbol() && magicnumber == OrderMagicNumber() && OrderType() == OP_SELL ) {
            Output = OrderClose( OrderTicket(), OrderLots(), Ask, 3 ) ;
            //PrintFormat( "--| Close by [ %s ] Magic Number = %d, TF = %dM, Close Sell", Symbol(), magicnumber, Period() ) ;
            //SendNotification( "Close Sell : " + Symbol() + ", MG : " + IntegerToString( magicnumber ) + ", TF: " + IntegerToString( Period() ) ) ;
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
//double MaxPrice = -9999999 ;
//double MinPrice = 9999999 ;

string CurrentOrder = "" ;

string CurrentTime_Backup() {
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

string DelCurrentTime() {
   string Output = "" ;
   int days     = TimeDay( CurrentCountryGMT( +7 ) ) ;
   int months   = TimeMonth( CurrentCountryGMT( +7 ) ) ;
   int years    = TimeYear( CurrentCountryGMT( +7 ) ) + 0 ;
   int Hr       = TimeHour( CurrentCountryGMT( +7 ) ) ;
   int Min      = TimeMinute( CurrentCountryGMT( +7 ) ) ;
   int Sec      = TimeSeconds( CurrentCountryGMT( +7 ) ) ;
   string Date  = IntegerToString( years ) + "-" + IntegerToString( months ) + "-" + IntegerToString( days ) + " 00:00:00" ;
   return Date ;
}//end function

string CurrentTime() {
   string Output = "" ;
   int days     = TimeDay( CurrentCountryGMT( +7 ) ) ;
   int months   = TimeMonth( CurrentCountryGMT( +7 ) ) ;
   int years    = TimeYear( CurrentCountryGMT( +7 ) ) + 0 ;
   int Hr       = TimeHour( CurrentCountryGMT( +7 ) ) ;
   int Min      = TimeMinute( CurrentCountryGMT( +7 ) ) ;
   int Sec      = TimeSeconds( CurrentCountryGMT( +7 ) ) ;
   string Date  = IntegerToString( years ) + "-" + IntegerToString( months ) + "-" + IntegerToString( days ) + " " + IntegerToString( Hr ) + ":" + IntegerToString( Min ) + ":" + IntegerToString( Sec ) ;
   return Date ;
}//end function

datetime CurrentCountryGMT( int YourCountryGMTOffset ) {
   int CountyGMTOffset = 3600 * YourCountryGMTOffset;
   return ( CountyGMTOffset + TimeGMT() );
}//end function

 int BB_Period = 50 ;
 double BB_SD  = 2.0 ;
 double HL_Entry = 0 ;
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
      ///* No          */     IntegerToString( Count ) + "\t"
      /* No          */     "Ord"+ IntegerToString( Count ) + "\t"
      /* Tactir      */     + "Breakout\t"
      /* Symbol      */     + Symbol() + "\t"
      /* TF          */     + IntegerToString( Period() ) + "\t"
      /* Order       */     + Order + "\t"
      /* Entry Date  */     + CurrentTime() + "\t"
      /* Entry Price */     + DoubleToStr( Price, D ) + "\t"
      /* SL    Price */     + DoubleToStr( SL_Prices, D ) + "\t"
      /* Entry BB    */     + DoubleToStr( BBP, 2 ) + "\t"
      /* Entry Day   */     + Days + "\t"
   ;
   
   HL_Entry = ( HighPrice - LowPrice ) / Point ;
   return Output ;
}//end function


double C_Price = 0 ;
int first_case = 0 ;

bool IsStoUp() {
   double Sto_main   = iStochastic( Symbol(), PERIOD_CURRENT, 5, 3, 3, MODE_SMA,0,MODE_MAIN, 0 ) ;
   double Sto_signal = iStochastic( Symbol(), PERIOD_CURRENT, 5, 3, 3, MODE_SMA,0,MODE_SIGNAL, 0 ) ;
   return Sto_main > StoHigh && Sto_signal > StoHigh ;
}//end function

bool IsStoDown() {
   double Sto_main   = iStochastic( Symbol(), PERIOD_CURRENT, 5, 3, 3, MODE_SMA,0,MODE_MAIN, 0 ) ;
   double Sto_signal = iStochastic( Symbol(), PERIOD_CURRENT, 5, 3, 3, MODE_SMA,0,MODE_SIGNAL, 0 ) ;
   return Sto_main < StoLow && Sto_signal < StoLow ;
}//end function

//---------------------------------------------------------------

int diff = 5 ;
string state_highprice = "CHR1" ;



//---------------------------------------------------------------

string state_lowprice = "CHG1" ;
int gMarkBar1, gMarkBar2, gMarkBar3 ;
datetime gT1, gT2, gT3 ;
void Mark_LowPrice() {

   //----| State : Change State
   if( state_lowprice == "CHG1" ) {
      if( IsStoUp() )   state_lowprice = "G1" ; 
      if( IsStoDown() ) state_lowprice = "R1" ;      
   }//end if
   
   if( state_lowprice == "CHR1" ) {
      if( IsStoDown() ) state_lowprice = "R1" ;
      if( IsStoUp() )   state_lowprice = "G2" ;
   }//end if
   
   //----| State : G1
   if( state_lowprice == "G1" ) {
      DrawLine( "temp_bar_g" + IntegerToString( obj ), Salmon ) ;
      gMarkBar1          = Bars   ;
      gT1                = TimeCurrent() ;
      state_lowprice   = "CHG1" ;
   }//end if
   
   //----| State : G1
   if( state_lowprice == "R1" ) {
      DrawLine( "temp_bar_g" + IntegerToString( obj ), Lime ) ;
      gMarkBar2          = Bars ;
      gT2                = TimeCurrent() ;
      state_lowprice   = "CHR1" ;
   }//end if

   //----| State : R2
   if( state_lowprice == "G2" ) {
      DrawLine( "temp_bar_g" + IntegerToString( obj ), Salmon ) ;
      gMarkBar3          = Bars ;
      gT3                = TimeCurrent() ;
      state_lowprice     = "CHG1" ;
      
      //----------
      obj++ ;
      LowPrice  = FindLow( gMarkBar1, gMarkBar3 ) ;
      DrawL( "Low", gT1, LowPrice, gT3, LowPrice, Red ) ;
      if( DrawMode == DrawOn ) DrawTempLine( "l", LowPrice ) ;
      
      MarkBar1          = Bars   ;
      T1                = TimeCurrent() ;
      
   }//end if

}//end function

//---------------------------------------------------------------

string state = "CHR1" ;

int l_obj = 0 ;
void DrawL( string obj_name, datetime t1, double p1, datetime t2, double p2, color CC = White, bool RayOn = FALSE ) {
   ObjectCreate( obj_name + IntegerToString( l_obj ), OBJ_TREND, 0, t1, p1, t2, p2 ) ;
   ObjectSet(    obj_name + IntegerToString( l_obj ), OBJPROP_COLOR, CC );          //Color of this Object
   ObjectSet(    obj_name + IntegerToString( l_obj ), OBJPROP_STYLE, STYLE_SOLID );    //Set Line to Solid
   ObjectSet(    obj_name + IntegerToString( l_obj ), OBJPROP_WIDTH, 2 );              //Set Width of Line
   ObjectSet(    obj_name + IntegerToString( l_obj ), OBJPROP_RAY_RIGHT, RayOn );      //Set Ray
   
   ObjectSet( obj_name + IntegerToString( l_obj ), OBJPROP_PRICE1, p1 ) ;
   ObjectSet( obj_name + IntegerToString( l_obj ), OBJPROP_PRICE2, p2 ) ;
   ObjectSet( obj_name + IntegerToString( l_obj ), OBJPROP_TIME1, t1 ) ;
   ObjectSet( obj_name + IntegerToString( l_obj ), OBJPROP_TIME2, t2 ) ;
   //l_obj++ ;
}//end function

void DrawTempLine( string obj_name, double TargetPrice, color CC = Pink )  {
   ObjectCreate(  obj_name + "_t_l", OBJ_HLINE, 0, 0, 0 );            //Declare HLine Object
   ObjectSet(     obj_name + "_t_l", OBJPROP_COLOR, CC );              //Color of this Object
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

string Trim( string input_string ){
   return StringTrimLeft( StringTrimRight( input_string ) );
}//end function

//+------------------------------------------------------------------+
//|                                                           mr.mq4 |
//|                              Copyright 2022, Thailand Fx Warrior |
//|                                https://www.thailandfxwarrior.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2022, Thailand Fx Warrior"
#property link      "https://www.thailandfxwarrior.com"
#property version   "1.01"
#property strict

enum MergeEnable {
   MergeOff ,  //Off
   MergeOn  ,  //On
} ;
enum CalEnum {
   CalTick ,    //On Tick
   CalCandle  , //On Candle
} ;
enum EnableTestEntry {
   TestEntryOff ,    //Off
   TestEntryOn  ,    //On
} ;
enum TradingRecordEnum {
   TR_Off ,    //Off
   TR_On  ,    //On
} ;

 string thfx_snowball_slipter_0 = "====| G E N E R A L |====" ; //---------------------------
 CalEnum     CalMode            = CalCandle ;   //Calculate Mode
 double EquityEnd               = 0 ;            //Equity End
 EnableTestEntry TestMode       = TestEntryOff ; //Test Entry Mode (On/Off)
 MergeEnable MergeMode          = MergeOn ;      //Merge Mode (On/Off)
enum MomentumEnum {
   MomentumOff ,  //Off
   MomentumOn  ,  //On
} ;
 MomentumEnum MomentumMode = MomentumOff ; //Momentum Mode (Off/On)
enum DiscountMode {
   DiscountOff ,  //Off
   DiscountOn  ,  //On - Bias
   //DiscountBoth , //On - Both Direction
} ;
enum ShowDashboard {
   Show_off , //Off
   Show_on  , //On
} ;
 DiscountMode DiscountSelect    = DiscountOff ;                           //----| Discount Mode (Off/On)
 string thfx_snowball_slipter_1 = "====| M R |====" ; //---------------------------
 ShowDashboard ShowMode = Show_off ;    //Dashboard
input int    MG_Buy                  = 1 ;   //Magic Number Buy
input int    MG_Sell                 = 2 ;   //Magic Number Sell

input string PtsStepString    = "0,170,135,265,285,685,0,0,0,0,0,0,0"    ;         // Point Step
input string LotString        = "0.01,0.02,0.04,0.05,0.07,0.07,0,0,0,0,0,0,0"  ;   // Lot Set
input int    BB_Period        = 50 ;                                               // BB Period
input double BB_SD            = 2.0 ;                                              // BB SD
input int    SLPoint                  = 3000 ; // SL Point

 ENUM_MA_METHOD MA_Mode  = MODE_SMA ;                                         // MA Mode
 //string PtsStepString      = "0,170,135,265,285,685,0,0,0,0,0,0,0"    ;          // Point Step
 //string LotString          = "0.01,0.02,0.04,0.05,0.07,0.07,0,0,0,0,0,0,0"  ;    // Lot Set
 //int    BB_Period          = 50 ;                                                // MA Period
 //ENUM_MA_METHOD MA_Mode    = MODE_SMA ;                                          // MA Mode
 //double BB_SD        = 2.0 ;                                                     // MA SD

enum FixLotEnum {
   FixLotOff , //Off
   FixLotOn  , //On
} ;

 FixLotEnum FixLotMode = FixLotOff ; //Fix First Lot (Off/On)
 string thfx_snowball_slipter_4 = "====| Special Mode |====" ; //---------------------------
input string Cmmt = "Bot" ;                     //Order Comment
 TradingRecordEnum TR_Mode = TR_Off ;   //Trading Record csv file (Off/On)
enum SelectBestModeEnum {
   Select_Off , //Off
   Select_On  , //On
} ;
 SelectBestModeEnum SelectBestMode = Select_Off ; // Select Best MA Mode (Off/On)

enum WaitEnum {
   WaitOff , //Wait for Close Price
   WaitOn  , //When Signal Appear
} ;
 WaitEnum WaitMode = WaitOff ; // First Order Condition
enum CalculateEnum {
   CalOff , //On Close Price
   CalOn  , //On Tick
} ;
 string Secret = "" ; //Secret

enum SD_Exit_Enum {
   SD_Exit_Off ,  // Off
   SD_Exit_On  ,  // On
} ;
 SD_Exit_Enum SD_Exit_Mode = SD_Exit_Off ;    //------| SD Exit Mode (Off/On)
 double BB_SD_Exit = 1.0 ; //MA SD (Exit)

enum BB_Close_Enum {
//   BB_Close_Off     , //TP Point
   BB_Close_1SD     , //1SD
   BB_Close_MA      , //MA
   BB_Close_BB_1SD  , //Opposite 1SD
   BB_Close_BB      , //Opposite BB
} ;
input BB_Close_Enum BB_Close_Mode = BB_Close_MA ;    // Close Mode
 int TPPoint = 40 ;                              // TP Points
input CalculateEnum CalculateMode = CalOn ; // Working Mode

//---------------------| FILE - HANDLERING |---------------------//
 string x3 = "====| F I L E |====" ;
 string      f_inputs  = "TR";              // ----| File Name
 string      FileNames = "MR_" + Symbol() + "_" + f_inputs + "_" + IntegerToString( Period() ) + "min" + ".csv" ;
 //string      FileNames = "C:/MR_" + Symbol() + "_" + f_inputs + "_" + IntegerToString( Period() ) + "min" + ".csv" ;
//---------------------| FILE - HANDLERING |---------------------//

 int    PointStep               = 40 ;     //Point Step (pts)
 int    TakeProfit              = 40 ;     //Take Profit (pts)
 int    MergePoint              = 200 ;    //Merge Point (pts)
 int    MaxOrder                = 999 ;     //Max Order
 double Lot                     = 0.05 ;   //Start Lot
 double Multiple                = 1.2 ;    //Multiple
enum CloseEnum {
   CloseBy1SD ,   //1SD
   CloseByMean ,  //Mean
} ;
 CloseEnum CloseMode = CloseByMean ; //Exit - 1st Order Method

 string thfx_snowball_slipter_2 = "====| T A R G E T    TO    R E C O V E R Y |====" ; //---------------------------
 int    Target_MG_Buy           = 0 ;      //Magic Number Buy
 int    Target_MG_Sell          = 0 ;      //Magic Number Sell
 int    EnableWhenBuy           = 1 ;      //Enable with found Buy Position (orders)
 int    EnableWhenSell          = 1 ;      //Enable with found Sell Position (orders)
 double CloseProfit             = 10 ;     //Clear Position @ Profit (+$)
enum AutoLotEnum {
   AutoLotOff ,   //Off
   AutoLotOn  ,   //On
} ;
enum RiskEnum {
   RiskOff ,      //Off
   RiskOn ,       //On
} ;

 string thfx_snowball_slipter_7 = "====| A U T O    L O T |====" ; //---------------------------
 AutoLotEnum    AutoLotMode     = AutoLotOff ;   //Auto Lot Mode (On/Off)
 double         Divide          = 3000 ;         //Divide Ratio

 string thfx_snowball_slipter_3 = "====| R I S K    M A N A G E M E N T |====" ; //---------------------------
 RiskEnum       RiskMode        = RiskOff ;      //Risk Management Mode (On/Off)
 int            CutLossDD       = 30 ;           //Cut Loss (%)

string PointStepSet[] ;
string LotSet[] ;
void PtsStepSplit()  {
   string Split = ","; ushort u_sep; int k; u_sep = StringGetCharacter( Split , 0 );
   k = StringSplit( PtsStepString , u_sep , PointStepSet );
}//end function

void LotSplit()  {
   string Split = ","; ushort u_sep; int k; u_sep = StringGetCharacter( Split , 0 );
   k = StringSplit( LotString , u_sep , LotSet );
}//end function

string EA_Name = "MR" ;
string key = "" ;

string spliter = "," ;

//--------------------------------------| MANUAL SETTING
string ReadComment( int MG ) {
   string Output = "" ;
   if( Secret != "" ) {
      for( int i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderMagicNumber() == MG ) {
               Output = OrderComment() ;
               break ;
            }//end if
         }//end if
      }//end for
   }//end if
   return Output ;
}//end function

int count_confirm = 0 ;

int OnInit()  {
   if( !IsTesting() ) if( ShowMode == Show_on ) DrawSolidPanel( 17, EA_Name ) ;
   return(INIT_SUCCEEDED);
}//end function

void ShowInfo() export {
   DrawHeadline() ;
   DrawNumberInfo() ;
}//end function

void DrawNumberInfo()  {
   string s     = "";
   string text  = "";
   string label = "";
   int    space = 90 + 70;
   int    x = space + 40, y = 30 + 20;
   //------------|   Trading Pair
   //x = x; y += 0; text = "$ " + DoubleToStr( AccountBalance(), 2 ) ";
   x = x; y += 0; text = "$ " + DoubleToStr( AccountBalance(), 2 ) + " ( Lot = " + DoubleToStr( TotalLot(), 2 ) + " )";
   label = EA_Name + "Balance";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "$ " + DoubleToStr( AccountFreeMargin(), 2 );
   label = EA_Name + "FreeMargin";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   DrawdownCalculate();
   //x = x; y += 20; text = DoubleToStr( DD, 2 ) + " %" + " ( MaxDD = " + DoubleToStr( MaxDD, 2 ) + " %)";
   x = x; y += 20; text = DoubleToStr( DD, 2 ) + "%" + " (" + DoubleToStr( MaxDD, 2 ) + "%)";
   //x = x; y += 20; text = DoubleToStr( DD, 2 ) + " %";
   label = EA_Name + "Drawdowns";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "$ " + DoubleToStr( ProfitAll(), 2 );
   label = EA_Name + "TTProfit";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );

   x = x; y += 20; text = "$ " + DoubleToStr( AccountEquity(), 2 );
   label = EA_Name + "Equity";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
  
   
  string ex = "" ;
   //if( ExpiredDate != 0 )
   //   ex = "" + DoubleToStr( ( ExpiredDate - TimeCurrent() ) / ( 3600 * 24 ), 0 ) + " Days" ;
   //else
   //   ex = "Unlimited" ;
      
   x = x; y += 20; 

   //--------------- 
   
   string date_s = "" ;
   
   text = "Unlimited" ;
   
   label = EA_Name + "ordernaja";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "www.ThailandFxWarrior.com" ;
   label = EA_Name + "ExpiredDateAndTime";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
}//end function

void DrawSolidPanel( int row, string EA_Names ) export {
   int r;
   int mCorn     = 0;
   string bgText = "ggggggggggggggggggggg";
   for( r = 0 ; r < row ; r++ ){
      ObjectCreate( EA_Names + "PanelArea" + DoubleToStr( r, 0 ), OBJ_LABEL, 0, 0, 0, 0, 0 );
      ObjectSetText( EA_Names + "PanelArea" + DoubleToStr( r, 0 ), bgText, 10, "Webdings" );
      ObjectSet( EA_Names + "PanelArea" + DoubleToStr( r, 0 ), OBJPROP_CORNER, mCorn );
      ObjectSet( EA_Names + "PanelArea" + DoubleToStr( r, 0 ), OBJPROP_BACK, false );
      ObjectSet( EA_Names + "PanelArea" + DoubleToStr( r, 0 ), OBJPROP_XDISTANCE, 70 );
      ObjectSet( EA_Names + "PanelArea" + DoubleToStr( r, 0 ), OBJPROP_YDISTANCE, ( r + 1 ) * 10 + 8 );
      ObjectSet( EA_Names + "PanelArea" + DoubleToStr( r, 0 ), OBJPROP_COLOR, PowderBlue );
   }//end for
   
}//end function

void DrawText( string label, string text, int font_size, int x, int y, color FontColor, int Position_Cornor = NULL ) export {
   ObjectCreate( label ,OBJ_LABEL,0,0,0,0,0);
   switch( Position_Cornor ){
      case 0: ObjectSet( label, OBJPROP_CORNER,0); break;
      case 1: ObjectSet( label, OBJPROP_CORNER,1); break;
      case 2: ObjectSet( label, OBJPROP_CORNER,2); break;
      case 3: ObjectSet( label, OBJPROP_CORNER,3); break;
      case 4: ObjectSet( label, OBJPROP_CORNER,4); break;
      default: ObjectSet( label, OBJPROP_CORNER,0); break;
   }//end switch
   ObjectSet( label,OBJPROP_XDISTANCE,x);
   ObjectSet( label,OBJPROP_YDISTANCE,y);
   ObjectSetText( label, text, font_size ,"Tahoma", FontColor);
}//end function

void DrawHeadline() export {
   string s     = "";
   string text  = "";
   string label = "";
   int    space = 10 + 70;
   int    x = 0, y = 30;
   //------------|   Trading Pair
   x += space; y = y; text = "        " + EA_Name;
   label = EA_Name + "EANameX";
   DrawText( label, text, 12, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "Balance : ";
   label = EA_Name + "BalanceX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "Free Margin : ";
   label = EA_Name + "FreeMarginX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "Drawdown : ";
   label = EA_Name + "DrawdownX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "Total Profit : ";
   label = EA_Name + "TTProfitX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );

   x = x; y += 20; text = "Equity : ";
   label = EA_Name + "EquityX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );

   x = x; y += 20; text = "Expired : ";
   label = EA_Name + "ActivateAccountX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );

}//end function

void DrawHeadline_expire() export {
   string s     = "";
   string text  = "";
   string label = "";
   int    space = 10 + 70;
   int    x = 0, y = 30;
   //------------|   Trading Pair
   x += space; y = y; text = "        " + EA_Name;
   label = EA_Name + "EANameX";
   DrawText( label, text, 12, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "YOU CANNOT ACCESS THIS EA";
   label = EA_Name + "BalanceX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "Because ...";
   label = EA_Name + "FreeMarginX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "1. Your key expired.";
   label = EA_Name + "DrawdownX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );
   
   x = x; y += 20; text = "2. You enter wrong key, please check white space";
   label = EA_Name + "TTProfitX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );

   x = x; y += 20; text = "Contact me > http://m.me/thailandfxwarrior";
   label = EA_Name + "EquityX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );

   x = x; y += 20; text = "";
   label = EA_Name + "ActivateAccountX";
   DrawText( label, text, 10, x, y, Black, CORNER_LEFT_UPPER );

}//end function

int obj = 0 ;
void OnDeinit( const int reason ) {
}//end function

//---------------------| FILE - HANDLERING |---------------------//

int BarStart = 0 ;
int data_connect = 0 ;
string Data_1() {      //----| Tracking when already entry new order
   string Output = "" ;

   string Direction = "NONE" ;
   if( OrdersTotalMG( MG_Buy )  > 0 && OrdersTotalMG( MG_Sell ) == 0 ) Direction = "Buy" ;
   if( OrdersTotalMG( MG_Sell ) > 0 && OrdersTotalMG( MG_Buy  ) == 0 ) Direction = "Sell" ;
   BarStart = iBars( Symbol(), PERIOD_CURRENT ) ;
   
   Output += 
      /* Loop Num    */     IntegerToString( TotalOrderLoop ) + spliter
      /* Symbol      */     + Symbol() + spliter
      /* TF          */     + IntegerToString( Period() ) + spliter
      /* Direction   */     + Direction + spliter
      /* MA          */     //+ IntegerToString( BB_Period ) + "" + spliter
      /* Entry Date  */     //+ CurrentTime() + "" + spliter
   ;
   data_connect = 1 ;
   return Output ;
}//end function

int      TotalOrderLoop = 1 ;
double   MaxProfit      = 0 ;
double   MaxLoss        = 0 ;
double   AllLots        = 0 ;
double   PL             = 0 ;
string Data_2() {       //----| Tracking when close all order (before close all order)
   string Output = "" ;
   if( MaxLoss <= 0 ) MaxLoss = 1 ; 
   Output += 
      /* Exit Date      */     //CurrentTime() + spliter
      /* Holding HR     */     DoubleToStr( ( ( Bars - BarStart ) * Period() ) / 60, 2 ) + spliter
      /* Total Orders   */     + IntegerToString( OrdersTotal() ) + spliter
      /* P/L            */     + DoubleToStr( PL, 2 ) + spliter
      /* Max Profit     */     + DoubleToStr( MaxProfit, 2 ) + spliter
      /* Max Loss       */     + DoubleToStr( MaxLoss, 2 ) + spliter
      /* Lot            */     + DoubleToStr( AllLots, 2 ) + spliter
      ///* Week Num       */     + DoubleToStr( TimeDayOfYear( TimeCurrent() ) / 7, 0 ) + "" + spliter
      /* Months         */     + DoubleToStr( TimeMonth( TimeCurrent() ), 0 ) + spliter
      /* Years          */     + DoubleToStr( TimeYear( TimeCurrent() ), 0 ) + spliter
      /* RRR            */     + DoubleToStr( MathAbs( PL / MaxLoss ), 2 ) + spliter
      /* Close Loop Day */     + DayString( TimeDayOfWeek( TimeCurrent() ) )
      + "\n" ;
   TotalOrderLoop++ ;
   MaxProfit      = 0 ;
   MaxLoss        = 0 ;
   PL             = 0 ;
   data_connect = 2 ;
   return Output ;
}//end function

string DayString( int CurrentDay ) {
   string Output = "" ;
   if( CurrentDay == 0 )         Output = "Sun" ;
   else if( CurrentDay == 1 )    Output = "Mon" ;
   else if( CurrentDay == 2 )    Output = "Tue" ;
   else if( CurrentDay == 3 )    Output = "Wed" ;
   else if( CurrentDay == 4 )    Output = "Thu" ;
   else if( CurrentDay == 5 )    Output = "Fri" ;
   else if( CurrentDay == 6 )    Output = "Sat" ;
   return Output ;
}//end function

void CurrentPL() {
   int i = 0 ;
   double Sum  = 0 ;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) Sum += OrderProfit() + OrderSwap() + OrderCommission() ;
      PL = Sum ;
   }//end if
}//end function

void FindMaxProfit() {
   int i = 0 ;
   double Sum  = 0 ;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) Sum += OrderProfit() + OrderSwap() + OrderCommission() ;
      if( Sum >= MaxProfit ) MaxProfit = Sum ;
   }//end if
}//end function

void FindAllLots() {
   int i = 0 ;
   double Sum  = 0 ;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) Sum += OrderLots() ;
      AllLots = Sum ;
   }//end if
}//end function

void FindMaxLoss() {
   int i = 0 ;
   double Sum  = 0 ;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) Sum += OrderProfit() + OrderSwap() + OrderCommission() ;
      if( Sum <= MaxLoss ) MaxLoss = Sum ;
   }//end if
}//end function

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
//---------------------| FILE - HANDLERING |---------------------//

int LastBar = 0 ;
double LotManagement = 0 ;

int Loop  = 0 ;
double bbb = 0 ;
double sss = 0 ;
double DD_Pts_Array[ 1000 ] ;
bool isActive = FALSE ;

int LastH4Bar = 0 ;
string ssss = "" ;
int Main_SL = 0 ;

void OnTick()  {
   string date_s = "" ;
   
   if( TRUE ) {
   
      if( !IsTesting() ) HideTestIndicators( TRUE ) ;
      
      bool C_Mode = FALSE ;
      if( CalculateMode == CalOff )       C_Mode = LastBar != Bars ;
      else if( CalculateMode == CalOn )   C_Mode = TRUE ;
      
      if( C_Mode ) {
         if( !IsTesting() ) if( ShowMode == Show_on ) ShowInfo() ;
         
         PtsStepSplit() ;
         LotSplit() ;
      
         if( ArraySize( PointStepSet ) <= 0 || ArraySize( LotSet ) <= 0 ) {
            Alert( "Lot Step & Point Step must be the same set !" ) ;
            ExpertRemove() ;
         }//en if

         LotManagement = StringToDouble( LotSet[0] ) ;
         
         if( TRUE ) {
            if( SignalFromMeanReverse() == "Buy"  && OrdersTotalMG( MG_Buy ) == 0 )  {
               OrderBuy( MG_Buy, 0, SLPoint, LotManagement ) ;
               AutoSL( MG_Buy ) ;
            }
            if( SignalFromMeanReverse() == "Sell" && OrdersTotalMG( MG_Sell ) == 0 ) {
               OrderSell( MG_Sell, 0, SLPoint, LotManagement ) ;
               AutoSL( MG_Sell ) ;
            }
         }//end if
         
         //---------------| START
         if( OrdersTotalMG( MG_Buy ) > 0 && OrdersTotalMG( MG_Buy ) < ArraySize(LotSet) ) {
            LotManagement = StringToDouble( LotSet[ OrdersTotalMG( MG_Buy ) ] ) ;
            Martingale( MG_Buy, 0, (int)StringToInteger( PointStepSet[ OrdersTotalMG( MG_Buy ) ] ), LotManagement, Multiple, "Buy", "No", key ) ;
            AutoSL( MG_Buy ) ;
         }//end if
            
         if( OrdersTotalMG( MG_Sell ) > 0 && OrdersTotalMG( MG_Sell ) < ArraySize(LotSet) ) {
            LotManagement = StringToDouble( LotSet[ OrdersTotalMG( MG_Sell ) ] ) ;
            Martingale( MG_Sell, 0, (int)StringToInteger( PointStepSet[ OrdersTotalMG( MG_Sell ) ] ), LotManagement, Multiple, "Sell", "No", key ) ;
            AutoSL( MG_Sell ) ;
         }//end if
         LastBar = Bars ;
      }//end if
   } else {
      Comment( "" ) ;
   }//end if Expired

   //----| Exit Condition
   if( OrdersTotal() > 0 ) {
      if( OrdersTotalMG( MG_Buy )  > 0 && MR_First_Exit() == "CloseBuy"  ) CloseOnlyMG( MG_Buy ) ;
      if( OrdersTotalMG( MG_Sell ) > 0 && MR_First_Exit() == "CloseSell" ) CloseOnlyMG( MG_Sell ) ;
   }//end if
   
}//end function

//----------------------------------------------------------
void AutoSL( int MG ) {
   int Total = OrdersTotalMG( MG ) ;
   int t = 0 ;
   double CurrentSL = 0 ;
   if( Total > 0 ) {
      CurrentSL = FindSLMG( MG ) ;
      for( int i = 0 ; i < Total ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderMagicNumber() == MG && OrderSymbol() == Symbol() && OrderStopLoss() != CurrentSL ) {
               t = OrderModify( 
                  OrderTicket(), 
                  NormalizeDouble( OrderOpenPrice(), Digits ), 
                  NormalizeDouble( CurrentSL, Digits ), 
                  0, 
                  0, Blue
               ) ;
               if( t == 0 ) {
                  Print("Error in OrderModify. Error code=",GetLastError()); 
               } else {
                  Print( "--| Modify Stop Loss Complete." ) ;
               }//end if
            }//end if
         }//end if
      }//end for
   }//end if
}//end function
//----------------------------------------------------------

double TP_Price_Buy = 0 ;
double TP_Price_Sell = 0 ;
double AVG_Price_Buy = 0 ;
double AVG_Price_Sell = 0 ;
void MergeAll( string Bias, int TarketPoints, int WithOutMG = -1, string keys = "" ) export {
   int    i        = 0;
   double TP_Price = 0;
   double P        = 0;
   
   if( TRUE ) {
   
      double AllLot     = AllLotSymbol();
      double AllPrice   = AllPriceSymbol();
      
      int j = 0 ;
      
      bool WithOutMGCondition = TRUE ;
      
      if( OrdersTotal() > 1 ) {
         if( Bias == "Buy" ) {
            //----------| Buy
            AllLot   = AllLotSymbol( "Buy" );
            AllPrice = AllPriceSymbol( "Buy" );
            for( i = 0 ; i < OrdersTotal() ; i++ ) {
               if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
                  if( WithOutMG != -1 ) WithOutMGCondition = OrderMagicNumber() != WithOutMG ;
                  if( OrderSymbol() == Symbol() && WithOutMGCondition ) {
                     P = MarketInfo( OrderSymbol(), MODE_POINT );
                     if( OrderType() == OP_BUY ) {
                        if( AllLot != 0 ) TP_Price = ( AllPrice / AllLot ) + ( TarketPoints * P );
                        else              TP_Price = 0 ;
                        TP_Price_Buy = TP_Price ;
                        AVG_Price_Buy = AllPrice / AllLot ;
                     }//end if
                     
                  }//end if
               }//end if
            }//end for
         } else if( Bias == "Sell" ) {
            //----------| Sell
            
            AllLot   = AllLotSymbol( "Sell" );
            AllPrice = AllPriceSymbol( "Sell" );
            for( i = 0 ; i < OrdersTotal() ; i++ ) {
               if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
                  if( WithOutMG != -1 ) WithOutMGCondition = OrderMagicNumber() != WithOutMG ;
                  if( OrderSymbol() == Symbol() && WithOutMGCondition ) {
                     P = MarketInfo( OrderSymbol(), MODE_POINT );
                     if( OrderType() == OP_SELL ) {
                        if( AllLot != 0 ) TP_Price = ( AllPrice / AllLot ) - ( TarketPoints * P );
                        else              TP_Price = 0;
                        TP_Price_Sell = TP_Price ;
                        AVG_Price_Sell = AllPrice / AllLot ;
                        //Print( "Hey" + "---> " + TP_Price_Sell ) ;
                        //ExpertRemove() ;
                     }//end if
                     
                  }//end if
               }//end if
            }//end for
         }//end if Bias
      }//end if
   }//end if key
}//end function


void GetErrorMessage() {
   int Error = GetLastError();
   switch(Error) {
      case 130 :
         PrintFormat("Wrong stops. Retrying.");
         RefreshRates();                         // Update data
         break;                                  // At the next iteration
      case 136 :
         PrintFormat("No prices. Waiting for a new tick..");
         while( RefreshRates() == false )        // To the new tick
            Sleep(1);                            // Cycle delay
         break;                                  // At the next iteration
      case 146 :
         PrintFormat("Trading subsystem is busy. Retrying ");
         Sleep(500);                             // Simple solution
         RefreshRates();                         // Update data
         break;                                  // At the next iteration
      // Critical errors
      case 2 : 
         PrintFormat("Common error.");
         break;                                   // Exit 'switch'
      case 5 : 
         PrintFormat("Old version of the client terminal.");
         break;                                   // Exit 'switch'
      case 64: 
         PrintFormat("Account is blocked.");
         break;                                   // Exit 'switch'
      case 133:
         PrintFormat("Trading is prohibited");
         break;                                   // Exit 'switch'
      default: 
         PrintFormat("Occurred error",Error);    //Other errors
   }//end switch
}//end function

int RiskManagement( int CutLossDDs ) export {
   int Output = 0 ;
   DrawdownCalculate() ;
   if( DD >= CutLossDD ) {
      Output = 1 ;
      Alert( "Risk management activate : DD Over than " + IntegerToString( CutLossDD ) + "%" ) ;
      PrintFormat( "Risk management activate : DD Over than " + IntegerToString( CutLossDD ) + "%" ) ;
      //ExpertRemove() ;
   }//end if
   return Output ;
}//end if

double DD, MaxDD = -999;
void DrawdownCalculate() {
   if( AccountBalance() > 0 ) DD = ( ( 1 - AccountEquity() / AccountBalance() ) * 100 );
   else                       DD = 1 ;
   if( DD > MaxDD ) {
      MaxDD = DD;
   }//end if
}//end function

double CalculateLot( int MG, double InitLot, double Multiples ) {
   double Output = 0 ; 
   Output = NormalizeDouble( InitLot * Multiple * MathPow( (double)Multiple, OrdersTotalMG( MG ) - 1 ), 2 );
   //PrintFormat( "%d) Multiple = %.2f -> Lot = %.2f", MG, Multiple, Output ) ;
   if( Output <= MarketInfo( Symbol(), MODE_MINLOT ) ) Output = MarketInfo( Symbol(), MODE_MINLOT ) ;
   if( Output >= MarketInfo( Symbol(), MODE_MAXLOT ) ) Output = MarketInfo( Symbol(), MODE_MAXLOT ) ;
   return Output ;
}//end function

string SignalFromMeanReverse() {
   string Output = "" ;
   int delay = 1 ;
   double RSI     = iRSI( Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, delay ) ;
   
   double UBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
   double LBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
   
   double UBand1SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, 1, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
   double LBand1SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, 1, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
   
   double MBand   = iMA( Symbol(), PERIOD_CURRENT, BB_Period, 0, BB_Period, PRICE_CLOSE, delay ) ;
   double Cs      = iClose( Symbol(), PERIOD_CURRENT, delay ) ;
   
   bool UBand_Buy  = FALSE ;
   bool UBand_Sell = FALSE ;
   if( WaitMode == WaitOn ) {
      UBand_Sell = Bid > UBand2SD || Ask > UBand2SD ;
      UBand_Buy  = Bid < LBand2SD || Ask < LBand2SD ;
   } else {
      UBand_Sell = Cs > UBand2SD ;
      UBand_Buy  = Cs < LBand2SD ;
   }//end if
     
   if( OrdersTotalMG( MG_Sell ) <= 0 && RSI > 70 && UBand_Sell ) {
      Output = "Sell" ;
   }
      
   if( OrdersTotalMG( MG_Buy ) <= 0 && RSI < 30 && UBand_Buy ) {
      Output = "Buy" ;
   }//end if
   
   return Output ;
}//end function

string MR_Select_Best_Mode( string SelectSide ) {
   string Output = "" ;
   double indi_SMA  = iMA( Symbol(), PERIOD_CURRENT, BB_Period, 0, MODE_SMA, PRICE_CLOSE,  0 ) ;
   double indi_EMA  = iMA( Symbol(), PERIOD_CURRENT, BB_Period, 0, MODE_EMA, PRICE_CLOSE,  0 ) ;
   double indi_SMMA = iMA( Symbol(), PERIOD_CURRENT, BB_Period, 0, MODE_SMMA, PRICE_CLOSE, 0 ) ;
   double indi_LWMA = iMA( Symbol(), PERIOD_CURRENT, BB_Period, 0, MODE_LWMA, PRICE_CLOSE, 0 ) ;
   int i = 0 ;
   double Profit_Arr_Buy[4] = { 0, 0, 0, 0 } ;
   double Profit_Arr_Sell[4] = { 0, 0, 0, 0 } ;
   
   if( SelectSide == "Buy" && OrdersTotalMG( MG_Buy ) > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderMagicNumber() == MG_Buy ) {
               Profit_Arr_Buy[ 0 ] += ( ( (indi_SMA - OrderOpenPrice()) / MarketInfo( Symbol(), MODE_POINT ) ) * OrderLots() * MarketInfo( Symbol(), MODE_TICKVALUE ) ) + OrderSwap() + OrderCommission() ;
               Profit_Arr_Buy[ 1 ] += ( ( (indi_EMA - OrderOpenPrice()) / MarketInfo( Symbol(), MODE_POINT ) ) * OrderLots() * MarketInfo( Symbol(), MODE_TICKVALUE ) ) + OrderSwap() + OrderCommission() ;
               Profit_Arr_Buy[ 2 ] += ( ( (indi_SMMA - OrderOpenPrice()) / MarketInfo( Symbol(), MODE_POINT ) ) * OrderLots() * MarketInfo( Symbol(), MODE_TICKVALUE ) ) + OrderSwap() + OrderCommission() ;
               Profit_Arr_Buy[ 3 ] += ( ( (indi_LWMA - OrderOpenPrice()) / MarketInfo( Symbol(), MODE_POINT ) ) * OrderLots() * MarketInfo( Symbol(), MODE_TICKVALUE ) ) + OrderSwap() + OrderCommission() ;
            }//end if
         }//end if
      }//end for
      //----| FIND MAX
      int FindMax = ArrayMaximum( Profit_Arr_Buy, WHOLE_ARRAY, 0 ) ;
      
      //string ag = "\n\n----| Buy\n" ;
      //for( i = 0 ; i < 4 ; i++ ) ag += "    MA[ " + IntegerToString( i ) + " ] : $ " + DoubleToStr( Profit_Arr_Buy[ i ], 2 ) + "\n" ;
      //ag += " ----| MAX = [ " + IntegerToString( FindMax ) + " ] $ " + DoubleToStr( Profit_Arr_Buy[ FindMax ], 2 ) ;
      //Comment( ag ) ;
      
      if( FindMax == 0 && ( Bid >= indi_SMA  || Ask >= indi_SMA  ) ) Output = "CloseBuy" ;
      if( FindMax == 1 && ( Bid >= indi_EMA  || Ask >= indi_EMA  ) ) Output = "CloseBuy" ;
      if( FindMax == 2 && ( Bid >= indi_SMMA || Ask >= indi_SMMA ) ) Output = "CloseBuy" ;
      if( FindMax == 3 && ( Bid >= indi_LWMA || Ask >= indi_LWMA ) ) Output = "CloseBuy" ;
   }//end if
   
   if( SelectSide == "Sell" && OrdersTotalMG( MG_Sell ) > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderMagicNumber() == MG_Sell ) {
               Profit_Arr_Sell[ 0 ] += ( ( (OrderOpenPrice()- indi_SMA) / MarketInfo( Symbol(), MODE_POINT ) ) * OrderLots() * MarketInfo( Symbol(), MODE_TICKVALUE ) ) + OrderSwap() + OrderCommission() ;
               Profit_Arr_Sell[ 1 ] += ( ( (OrderOpenPrice() - indi_EMA) / MarketInfo( Symbol(), MODE_POINT ) ) * OrderLots() * MarketInfo( Symbol(), MODE_TICKVALUE ) ) + OrderSwap() + OrderCommission() ;
               Profit_Arr_Sell[ 2 ] += ( ( (OrderOpenPrice() - indi_SMMA) / MarketInfo( Symbol(), MODE_POINT ) ) * OrderLots() * MarketInfo( Symbol(), MODE_TICKVALUE ) ) + OrderSwap() + OrderCommission() ;
               Profit_Arr_Sell[ 3 ] += ( ( (OrderOpenPrice() - indi_LWMA) / MarketInfo( Symbol(), MODE_POINT ) ) * OrderLots() * MarketInfo( Symbol(), MODE_TICKVALUE ) ) + OrderSwap() + OrderCommission() ;
            }//end if
         }//end if
      }//end for
      //----| FIND MAX
      int FindMax = ArrayMaximum( Profit_Arr_Sell, WHOLE_ARRAY, 0 ) ;
      
      //string ag = "\n\n----| Sell\n" ;
      //for( i = 0 ; i < 4 ; i++ ) ag += "    MA[ " + IntegerToString( i ) + " ] : $ " + DoubleToStr( Profit_Arr_Sell[ i ], 2 ) + "\n" ;
      //ag += "\n ----| MAX = [ " + IntegerToString( FindMax ) + " ] $ " + DoubleToStr( Profit_Arr_Sell[ FindMax ], 2 ) ;
      //Comment( ag ) ;
      
      if( FindMax == 0 && ( Bid <= indi_SMA  || Ask <= indi_SMA  ) ) Output = "CloseSell" ;
      if( FindMax == 1 && ( Bid <= indi_EMA  || Ask <= indi_EMA  ) ) Output = "CloseSell" ;
      if( FindMax == 2 && ( Bid <= indi_SMMA || Ask <= indi_SMMA ) ) Output = "CloseSell" ;
      if( FindMax == 3 && ( Bid <= indi_LWMA || Ask <= indi_LWMA ) ) Output = "CloseSell" ;
   }//end if
      
   return Output ;
}//end function

string MR_First_Exit() {
   string Output = "" ;
   int delay = 0 ;
   
   if( BB_Close_Mode == BB_Close_MA ) {
      double UBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
      double LBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
      double MBand   = iMA( Symbol(), PERIOD_CURRENT, BB_Period, 0, MODE_SMA, PRICE_CLOSE, delay ) ;
      if( OrdersTotalMG( MG_Buy  ) > 0 && ( Bid >= MBand || Ask >= MBand ) ) Output = "CloseBuy"  ;
      if( OrdersTotalMG( MG_Sell ) > 0 && ( Ask <= MBand || Bid <= MBand ) ) Output = "CloseSell" ;
   } else if( BB_Close_Mode == BB_Close_BB ) {
      double UBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
      double LBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
      if( OrdersTotalMG( MG_Buy  ) > 0 && ( Bid >= UBand2SD || Ask >= UBand2SD ) ) Output = "CloseBuy"  ;
      if( OrdersTotalMG( MG_Sell ) > 0 && ( Ask <= LBand2SD || Bid <= LBand2SD ) ) Output = "CloseSell" ;
   } else if( BB_Close_Mode == BB_Close_1SD ) {
      double UBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, 1.0, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
      double LBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, 1.0, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
      if( OrdersTotalMG( MG_Buy  ) > 0 && ( Bid >= LBand2SD || Ask >= LBand2SD ) ) Output = "CloseBuy"  ;
      if( OrdersTotalMG( MG_Sell ) > 0 && ( Ask <= UBand2SD || Bid <= UBand2SD ) ) Output = "CloseSell" ;
   } else if( BB_Close_Mode == BB_Close_BB_1SD ) {
      double UBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, 1.0, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
      double LBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, 1.0, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
      if( OrdersTotalMG( MG_Buy  ) > 0 && ( Bid >= UBand2SD || Ask >= UBand2SD ) ) Output = "CloseBuy"  ;
      if( OrdersTotalMG( MG_Sell ) > 0 && ( Ask <= LBand2SD || Bid <= LBand2SD ) ) Output = "CloseSell" ;
   }//end if
   
   return Output ;
}//end function

//string MR_First_Exit_OLD() {
//   string Output = "" ;
//   int delay = 0 ;
//   double RSI     = iRSI( Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, delay ) ;
//   
//   double UBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
//   double LBand2SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
//   
//   double UBand1SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD_Exit, 0, PRICE_CLOSE, MODE_UPPER, delay ) ;
//   double LBand1SD = iBands( Symbol(), PERIOD_CURRENT, BB_Period, BB_SD_Exit, 0, PRICE_CLOSE, MODE_LOWER, delay ) ;
//   
//   double MBand   = iMA( Symbol(), PERIOD_CURRENT, BB_Period, 0, MA_Mode, PRICE_CLOSE, delay ) ;
//   double Cs      = iClose( Symbol(), PERIOD_CURRENT, delay ) ;
//   
//   if( TRUE ) {
//      if( SD_Exit_Mode == SD_Exit_Off ) {
//         if( OrdersTotalMG( MG_Buy ) > 0 && ( Bid >= MBand || Ask >= MBand ) )   Output = "CloseBuy" ;
//         if( OrdersTotalMG( MG_Sell ) > 0 && ( Ask <= MBand || Bid <= MBand ) )  Output = "CloseSell" ;
//      } else if( SD_Exit_Mode == SD_Exit_On ) {
//         if( OrdersTotalMG( MG_Buy ) > 0 && ( Bid >= LBand1SD || Ask >= LBand1SD ) )   Output = "CloseBuy" ;
//         if( OrdersTotalMG( MG_Sell ) > 0 && ( Ask <= UBand1SD || Bid <= UBand1SD ) )  Output = "CloseSell" ;
//      }//end if
//   }//end if
//   
//   return Output ;
//}//end function

double FindSLMG( int MG ) {
   double Output = 0 ;
   if( OrdersTotalMG( MG ) > 0 ) {
      for( int i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderMagicNumber() == MG && OrderSymbol() == Symbol() ) {
               if( OrderStopLoss() != 0 ) {
                  Output = OrderStopLoss() ;
                  break ;
               }//end if
            }//end if
         }//end if
      }//for
   }//end if
   return NormalizeDouble( Output, Digits ) ;
}//end function

void Martingale( int MG, int TP, int PointSteps, double Lots, double Multiples, string Bias = "Buy", string PlaceTP = "No", string keys = "" ) {
   if( TRUE ) {
      double Bids = MarketInfo( Symbol(), MODE_BID ) ;
      double Asks = MarketInfo( Symbol(), MODE_ASK ) ;
      if( PlaceTP != "Yes" ) TP = 0 ;
      //--------------------------------------------------------------------| BUY
      if( Bias == "Buy" || Bias == "Both" ) {
         if( OrdersTotalMG( MG ) <= 0 ) OrderBuy( MG, TP, 0, Lots ) ;
         //----| Next Step : Buy - Martingale
         if( Diff( GetLowestPrice( MG ), Asks ) > PointSteps && GetLowestPrice( MG ) != 999999  )
            OrderBuy( MG, TP, 0, Lots ) ;
      }//end if
      
      //--------------------------------------------------------------------| SELL
      if( Bias == "Sell" || Bias == "Both" ) {
         if( OrdersTotalMG( MG ) <= 0 ) OrderSell( MG, TP, 0, Lots ) ;
         //----| Next Step : Sell - Martingale
         if( Diff( Bids, GetHighestPrice( MG ) ) > PointSteps && GetHighestPrice( MG ) != -999999 ) 
            OrderSell( MG, TP, 0, Lots ) ;
      }//end if
   }//end if key
   
}//end functoin


double GetHighestPrice( int MG ) export {
   double Output = -999999 ;
   int    i = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( MG == OrderMagicNumber() ) {
            if( OrderOpenPrice() > Output ) Output = OrderOpenPrice() ;
         }//end if
      }//end if
   }//end if
   return Output ;
}//end function

double GetLowestPrice( int MG ) export {
   double Output = 999999 ;
   int    i = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( MG == OrderMagicNumber() ) {
            if( OrderOpenPrice() < Output ) Output = OrderOpenPrice() ;
         }//end if
      }//end if
   }//end if
   return Output ;
}//end function

double GetLot( int MG ) export {
   double Output = 0 ;
   int    i = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( MG == OrderMagicNumber() ) {
            Output += OrderLots() ;
         }//end if
      }//end if
   }//end for
   return Output ;
}//end function

double TrackingLowestProfit( int MG ) export {
   double Output = 0 ;
   int    i      = 0 ;
   double Lowest = 999 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( MG == OrderMagicNumber() ) {
            if( OrderProfit() < Lowest ) {
               Lowest = OrderProfit() ;
            }//end if
         }//end if
      }//end if
   }//end for
   if( Lowest == 999 ) {
      Output = 0 ;
   } else {
      Output = Lowest ;
   }//end if
   return Output ;
}//end function

double ProfitAll() export {
   double Output = 0 ;
   int    i = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         Output += OrderProfit() + OrderCommission() + OrderSwap() ;
      }//end if
   }//end for
   return Output ;
}//end function

double ProfitMG( int MG ) export {
   double Output = 0 ;
   int    i = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( MG == OrderMagicNumber() ) {
            Output += OrderProfit() + OrderCommission() + OrderSwap() ;
         }//end if
      }//end if
   }//end for
   return Output ;
}//end function

void CloseOnlyMGProfit( int MG ) export {
   int Output = 0 ;
   int Exit   = 0 ;
   int    i   = 0 ;
   int    t   = 0 ;
   double Bids = MarketInfo( Symbol(), MODE_BID ) ; double Asks = MarketInfo( Symbol(), MODE_ASK ) ;
   do {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( MG == OrderMagicNumber() ) {
               if( OrderSwap() + OrderCommission() + OrderProfit() > 0 ) {
                  if( OrderType() == OP_BUY  ) t = OrderClose( OrderTicket(), OrderLots(), Bids, 3 ) ;
                  if( OrderType() == OP_SELL ) t = OrderClose( OrderTicket(), OrderLots(), Asks, 3 ) ;
                  else if( OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP ) t = OrderDelete( OrderTicket() ) ;
               }//end if
            }//end if
         }//end if
      }//end for
      Exit++ ;
   } while( Exit < 6 ) ;
}//end function

void CloseAll() export {
   int Output = 0 ;
   int Exit   = 0 ;
   int    i   = 0 ;
   int    t   = 0 ;
   double Bids = MarketInfo( Symbol(), MODE_BID ) ; double Asks = MarketInfo( Symbol(), MODE_ASK ) ;
   do {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderType() == OP_BUY  ) t = OrderClose( OrderTicket(), OrderLots(), Bids, 3 ) ;
            if( OrderType() == OP_SELL ) t = OrderClose( OrderTicket(), OrderLots(), Asks, 3 ) ;
            else if( OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP ) t = OrderDelete( OrderTicket() ) ;
         }//end if
      }//end for
      Exit++ ;
   } while( Exit < 6 ) ;
}//end function


void CloseOnlyMG( int MG ) {
   int Output = 0 ;
   int Exit   = 0 ;
   int    i   = 0 ;
   int    t   = 0 ;
   double Bids = MarketInfo( Symbol(), MODE_BID ) ; double Asks = MarketInfo( Symbol(), MODE_ASK ) ;
   SendNotification( "P/L = " + DoubleToStr( ProfitAll(), 2 ) ) ;
   do {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( MG == OrderMagicNumber() ) {
               if( OrderType() == OP_BUY  ) t = OrderClose( OrderTicket(), OrderLots(), Bids, 3 ) ;
               if( OrderType() == OP_SELL ) t = OrderClose( OrderTicket(), OrderLots(), Asks, 3 ) ;
               else if( OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP ) t = OrderDelete( OrderTicket() ) ;
            }//end if
         }//end if
      }//end for
      Exit++ ;
   } while( Exit < 6 ) ;
   
}//end function

double AllPriceSymbol( string T = "Buy" ) export {
   double Output = 0;
   int    i      = 0;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderSymbol() == Symbol() ) {
               if( OrderType() != OP_SELLLIMIT && OrderType() != OP_SELLSTOP && OrderType() != OP_BUYLIMIT && OrderTicket() != OP_BUYSTOP ) {
                  if( T == "Buy" ) {
                     if( OrderType() == OP_BUY ) Output += OrderOpenPrice() * OrderLots();
                  } else {
                     if( OrderType() == OP_SELL ) Output += OrderOpenPrice() * OrderLots();
                  }//end if
               }//end if
            }
         }//end if
      }//end for
   }//end if
   return Output;
}//end function

double AllLotSymbol( string T = "Buy" ) export {
   double Output = 0;
   int    i      = 0;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderSymbol() == Symbol() ) {
               if( OrderType() != OP_SELLLIMIT && OrderType() != OP_SELLSTOP && OrderType() != OP_BUYLIMIT && OrderTicket() != OP_BUYSTOP ) {
                  if( T == "Buy" ) {
                     if( OrderType() == OP_BUY ) Output += OrderLots();
                  } else {
                     if( OrderType() == OP_SELL ) Output += OrderLots();
                  }//end if
               }//end if                  
            }//end if
         }//end if
      }//end for
   }//end if
   return Output;
}//end function

double AllPrice( int MG, string T = "Buy" ) export {
   double Output = 0;
   int    i      = 0;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderSymbol() == Symbol() && OrderMagicNumber() == MG ) {
               if( OrderType() != OP_SELLLIMIT && OrderType() != OP_SELLSTOP && OrderType() != OP_BUYLIMIT && OrderTicket() != OP_BUYSTOP ) {
                  if( T == "Buy" ) {
                     if( OrderType() == OP_BUY ) Output += OrderOpenPrice() * OrderLots();
                  } else {
                     if( OrderType() == OP_SELL ) Output += OrderOpenPrice() * OrderLots();
                  }//end if
               }//end if
            }
         }//end if
      }//end for
   }//end if
   return Output;
}//end function

double AllLot( int MG, string T = "Buy" ) export {
   double Output = 0;
   int    i      = 0;
   if( OrdersTotal() > 0 ) {
      for( i = 0 ; i < OrdersTotal() ; i++ ) {
         if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
            if( OrderSymbol() == Symbol() && OrderMagicNumber() == MG ) {
               if( OrderType() != OP_SELLLIMIT && OrderType() != OP_SELLSTOP && OrderType() != OP_BUYLIMIT && OrderTicket() != OP_BUYSTOP ) {
                  if( T == "Buy" ) {
                     if( OrderType() == OP_BUY ) Output += OrderLots();
                  } else {
                     if( OrderType() == OP_SELL ) Output += OrderLots();
                  }//end if
               }//end if                  
            }//end if
         }//end if
      }//end for
   }//end if
   return Output;
}//end function

int OrdersTotalEA() {
   int Output = 0 ;
   int    i = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( OrderMagicNumber() != 0 ) {
            Output++ ;
         }//end if
      }//end if
   }//end for
   return Output ;
}//end function

double TotalLot() {
   double Output = 0 ;
   int    i = 0 ;
   for( i = 0 ; i < OrdersHistoryTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_HISTORY ) ) {
         Output += OrderLots() ;
      }//end if
   }//end for
   return Output ;
}//end function

int OrdersTotalMG( int MG ) export {
   int Output = 0 ;
   int    i = 0 ;
   for( i = 0 ; i < OrdersTotal() ; i++ ) {
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {
         if( MG == OrderMagicNumber() ) {
            Output++ ;
         }//end if
      }//end if
   }//end for
   return Output ;
}//end function

double first_buy_price = 0 ;
double first_sell_price = 0 ;
int OrderBuy( int MG, int TP, int SL, double Lots ) {
   double   TP_Price = 0 , SL_Price = 0 ;
   //if( TP != 0 ) TP_Price = NormalizeDouble( Ask + ( Point * TP ), (int)Digits ) ;
   //else          TP_Price = 0;
   
   if( SL != 0 ) SL_Price = NormalizeDouble( Ask - ( Point * SL ), (int)Digits );
   else          SL_Price = 0;
   //ExpertRemove() ;
   //Print( NormalizeDouble( Ask, (int)Digits ) + " | " + Lots + " | " + NormalizeDouble( SL_Price, (int)Digits ) + " | " + NormalizeDouble( TP_Price, (int)Digits ) ) ;
   if( OrderSend( Symbol(), OP_BUY , 
      NormalizeDouble( Lots, 2 ), 
      NormalizeDouble( Ask, (int)Digits ), 3, 
      NormalizeDouble( SL_Price, (int)Digits ), 
      NormalizeDouble( TP_Price, (int)Digits ), Cmmt + "-" + IntegerToString( Loop ), MG, 0, Blue ) ){ ; }
   if( OrdersTotalMG( MG ) == 1 ) first_buy_price = Ask ;
   else first_buy_price = 0 ;
   return 0 ;
}//end function

int OrderSell( int MG, int TP, int SL, double Lots ) {
   double   TP_Price = 0 , SL_Price = 0 ;
   //if( TP != 0 ) TP_Price = NormalizeDouble( Bid - ( Point * TP ), (int)Digits );
   //else          TP_Price = 0;
   
   if( SL != 0 ) SL_Price = NormalizeDouble( Bid + ( Point * SL ), (int)Digits );
   else          SL_Price = 0;
   //ExpertRemove() ;
   //Print( NormalizeDouble( Bid, (int)Digits ) + " | " + Lots + " | " + NormalizeDouble( SL_Price, (int)Digits ) + " | " + NormalizeDouble( TP_Price, (int)Digits ) ) ;
   if( OrderSend( Symbol(), OP_SELL, NormalizeDouble( Lots, 2 ), NormalizeDouble( Bid, (int)Digits ), 3, NormalizeDouble( SL_Price, (int)Digits ), NormalizeDouble( TP_Price, (int)Digits ), Cmmt + "-" + IntegerToString( Loop ), MG, 0, Red ) ){ ; }
   if( OrdersTotalMG( MG ) == 1 ) first_sell_price = Bid ; 
   else first_sell_price = 0 ;  
   return 0 ;
}//end function

double Diff( double V1, double V2 ) export {
   double Pts = MarketInfo( Symbol(), MODE_POINT ) ;
   double Output = 0 ;
   Output = ( V1 - V2 ) / Pts ;
   return Output ;
}//end function


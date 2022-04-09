//+------------------------------------------------------------------+
//|                                                  Stat_CSV_MR.mq4 |
//|                              Copyright 2022, Thailand Fx Warrior |
//|                                https://www.thailandfxwarrior.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Thailand Fx Warrior"
#property link      "https://www.thailandfxwarrior.com"
#property version   "1.00"
#property strict


#import "shell32.dll"   // MQL4-syntax-wrapper-Bo[#import]Container caller-side interface to DLL
int ShellExecuteW( int  hWnd, int lpVerb, string lpFile, int lpParameters, int lpDirectory, int nCmdShow );
#import                 // MQL4-syntax-wrapper-Eo[#import]Container

string EA_Name = "MR_" ;

 string x1 = "====| L I N E    A P I |====" ;    //-----------------------------------------
 string LineSDToken   = "";
 int    input_DD_Pts  = 0 ;  //Drawdown (pts)
 int    input_DD_Bars = 0 ;  //Drawdown (bars)

input string x2 = "====| B B |====" ;    //-----------------------------------------
input int    BB_Period = 110 ;
input double BB_SD     = 2.5 ;

input string x3 = "====| F I L E |====" ;    //-----------------------------------------
 string      f_input     = "MR";              // ----| File Name
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
 DrawLineEnum DrawMode = DrawOff ;         //

enum HeaderEnum {
   HeaderOff ,    //Off
   HeaderOn  ,    //On
} ;
 HeaderEnum HeaderMode = HeaderOn ; //Header Mode (On/Off)

enum ExitTypeEnum {
   ExitBidAsk ,      //Bid / Ask
   ExitHighLow  ,    //High / Low
} ;
 ExitTypeEnum ExitType = ExitHighLow ; //Exit Type

enum CaptureEnum {
   CaptureOff ,   //Off
   CaptureOn  ,   //On
} ;
 CaptureEnum CaltureMode = CaptureOff ;    //Capture Mode (On/Off)

enum CloseEnum {
   CloseBy1SD ,   //1SD
   CloseByMean ,  //Mean
} ;
input CloseEnum CloseMode = CloseByMean ; //Exit Order Method

 int s_width = 600 ;  // Capture - Width
 int s_high  = 400 ;  // Capture - High

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
   
   Sleep( 200 ) ;
   
   string Path = __PATH__ ;
   string StatWeb = "https://docs.google.com/spreadsheets/d/1nv7g1Pvihi8KCgqFDdBG4mH7fE5M1Puux13Zj7iBjN8/edit#gid=0" ;
   
   StringReplace( Path, __FILE__, "" ) ;
   StringReplace( Path, "MQL4\\Experts\\", "" ) ;
   StringReplace( Path, "ThailandFxWarrior\\", "" ) ;
   StringReplace( Path, "trader_tum\\", "" ) ;
   //ShellExecuteW( 0, "open", "notepad.exe " + Path + "tester\\files\\" + FileName, "", "", 1 );
   ShellExecuteW( 0, "edit", "" + Path + "tester\\files\\" + FileName, "", "", 1 );
   //ShellExecuteW( 0, "open", "start chrome " + StatWeb, "", "", 1 );
   
   //Print( "notepad.exe " + Path + "tester\\files\\" + FileName ) ;
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
        
         if( ticket != 0 ) {
            OrderCount++ ;
            CurrentOrder = "Buy" ;
            if( TRUE ) {
               DD_Price  = Ask ;
               Max_Price = Ask ;
               SL_Price = LowPrice ;
               if( TRUE ) sString += Data_1( OrderCount, "Buy", Ask, Digits, LowPrice ) ;
            }//end if
            BarStart = Bars ;
         }//end if
      }//end if
      
      if( Signal == "Sell" && OrdersTotal() == 0 ) {
         ticket = Sell() ;
        
         if( ticket != 0 ) {
            OrderCount++ ;
            CurrentOrder = "Sell" ;
            if( TRUE ) {
               DD_Price  = Bid ;
               Max_Price = Bid ;
               SL_Price = HighPrice ;
               if( TRUE ) sString += Data_1( OrderCount, "Sell", Bid, Digits, HighPrice ) ;
            }//end if
            BarStart = Bars ;
         }//end if
      }//end if
   
      if( OrdersTotal() > 0 ) {
         if( Signal == "CloseBuy" && CurrentOrder == "Buy" && OrdersTotal() != 0 ) {
            ticket = CloseAllBuy() ;
            if( ticket != 0 ) {
               if( TRUE ) sString += Data_2( Bid, Digits ) ;
               CurrentOrder = "" ;
            }//end if
         }//end if
         
         if( Signal == "CloseSell" && CurrentOrder == "Sell" && OrdersTotal() != 0 ) {
            ticket = CloseAllSell() ;
            if( ticket != 0 ) {
               if( TRUE ) sString += Data_2( Ask, Digits ) ;
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
               if( TRUE ) sString += Data_2( Bid, Digits ) ;
               CurrentOrder = "" ;
            }//end if
         }//end if
         
         if( Signal == "CloseSell" && CurrentOrder == "Sell" && OrdersTotal() != 0 ) {
            ticket = CloseAllSell() ;
            if( ticket != 0 ) {
               if( TRUE ) sString += Data_2( Ask, Digits ) ;
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
      H = iHigh( Symbol(), PERIOD_CURRENT, i ) ;
      if( Max < H ) {
         Max = H ;
      }//end if
   }//end if
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

int Ord = 0 ;

int Buy() {
   int Output = 0 ;
   int i = 0 ;
   C_Price = Order_Price ;
   if( OrdersTotal() == 0 ) {
      Output = OrderSend( Symbol(), OP_BUY, 0.01, Ask, 0, 0, 0, "" ) ;
      Order_Price = Ask ;
      Capture_Open() ;
   }//end if
   if( Output == -1 ) Output = 0 ;
   Ord++ ;
   return Output ;
}//end function

int Sell() {
   int Output = 0 ;
   int i = 0 ;
   C_Price = Order_Price ;
   if( OrdersTotal() == 0 ) {
      Output = OrderSend( Symbol(), OP_SELL, 0.01, Bid, 0, 0, 0, "" ) ;
      Order_Price = Bid ;
      Capture_Open() ;
   }//end if
   if( Output == -1 ) Output = 0 ;
   Ord++ ;
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

double SL_Price = 0 ;
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

int l_obj = 0 ;

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

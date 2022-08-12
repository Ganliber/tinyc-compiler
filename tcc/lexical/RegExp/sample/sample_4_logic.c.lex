TOKEN-TYPE          TOKEN-VALUE
-------------------------------------------------
T_Int               int
T_Identifier        main
(                   (
)                   )
{                   {
T_Print             print
(                   (
T_StringConstant    "0 && 0 is %d"
,                   ,
T_IntConstant       0
T_And               &&
T_IntConstant       0
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "0 && 1 is %d"
,                   ,
T_IntConstant       0
T_And               &&
T_IntConstant       1
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "1 && 0 is %d"
,                   ,
T_IntConstant       1
T_And               &&
T_IntConstant       0
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "1 && 1 is %d"
,                   ,
T_IntConstant       1
T_And               &&
T_IntConstant       1
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "0 || 0 is %d"
,                   ,
T_IntConstant       0
T_Or                ||
T_IntConstant       0
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "0 || 1 is %d"
,                   ,
T_IntConstant       0
T_Or                ||
T_IntConstant       1
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "1 || 0 is %d"
,                   ,
T_IntConstant       1
T_Or                ||
T_IntConstant       0
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "1 || 1 is %d"
,                   ,
T_IntConstant       1
T_Or                ||
T_IntConstant       1
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "!1 is %d"
,                   ,
!                   !
T_IntConstant       1
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "!0 is %d"
,                   ,
!                   !
T_IntConstant       0
)                   )
;                   ;
T_Return            return
T_IntConstant       0
;                   ;
}                   }

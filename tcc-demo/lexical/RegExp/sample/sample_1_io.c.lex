TOKEN-TYPE          TOKEN-VALUE
-------------------------------------------------
T_Int               int
T_Identifier        main
(                   (
)                   )
{                   {
T_Int               int
T_Identifier        n
;                   ;
T_Identifier        n
=                   =
T_ReadInt           readint
(                   (
T_StringConstant    "Please input an integer: "
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "Your input number is: %d"
,                   ,
T_Identifier        n
)                   )
;                   ;
T_Return            return
T_IntConstant       0
;                   ;
}                   }

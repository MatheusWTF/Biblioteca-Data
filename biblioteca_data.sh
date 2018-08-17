#!/bin/ksh -x
#############################################################
#                                                           #
#    Arquivo: biblioteca_data.sh                            #
#             16-08-2018                                    #
#                                                           #
#  Descricao: Biblioteca com funcoes para a manipulacao de  #
#             datas no formato YYYYMMDD                     #
#                                                           #
#############################################################
#===========================================================#
# Transforma uma data YYYYMMDD em No de Dias                #
#===========================================================#
function data_dias {
    # Argumento $1 = Data Referencia (YYYYMMDD)

    DATA=$1
    ANO=$(echo $DATA | cut -b1-4)
    MES=$(echo $DATA | cut -b5-6)
    DIA=$(echo $DATA | cut -b7-8)
    typeset -i y=$ANO m=$MES d=$DIA res
    (( m=(m+9)%12 ))
    (( y-=m/10 ))
    (( res=365*y+y/4-y/100+y/400+(m*306+5)/10+d-1 ))
    echo $res
    return 0
}

#===========================================================#
# Transforma um No de Dias em data YYYYMMDD                 #
#===========================================================#
function dias_data {
    # $1 = No de Dias

    typeset -i g=$1
    typeset -i y ddd mi 
    typeset -Z2 mm dd
    typeset -Z4 yy
    (( y=(10000*g+14780)/3652425 ))
    (( ddd=g-(365*y+y/4-y/100+y/400) ))
    [[ $ddd -lt 0 ]] && {
        (( y-=1 ))
        (( ddd=g-(365*y+y/4-y/100+y/400) ))
    }
    (( mi=(100*ddd+52)/3060 ))
    (( mm=(mi+2)%12+1 ))
    (( y+=(mi+2)/12 ))
    (( dd=ddd-(mi*306+5)/10+1 ))
    yy=$y
    echo $yy$mm$dd
    return 0
}

#===========================================================#
# Adiciona N dias a uma determinada data YYYYMMDD           #
#===========================================================#
function add_dias {
    # $1 = Data Referencia (YYYYMMDD); 
    # $2 = No Dias a Adicionar

    dias=$(data_dias $1)
    (( ndias=$dias + $2))
    novadata=$(dias_data $ndias)
    echo $novadata
    return 0
}

#===========================================================#
# Subtrai N dias a uma determinada data YYYYMMDD            #
#===========================================================#
function sub_dias {
    # $1 = Data Referencia (YYYYMMDD); 
    # $2 = No Dias a Subtrair

    dias=$(data_dias $1)
    (( ndias=$dias - $2))
    novadata=$(dias_data $ndias)
    echo $novadata
    return 0
}

#===========================================================#
# Checa se uma data YYYYMMDD e' valida                      #
#===========================================================#
function checa_data {
    # $1 = Data a ser Validada

    DATA="$1"
    RES=$(dias_data "$(data_dias $1)")

    if [ "$DATA" -eq "$RES" ]
    then
        echo "$DATA"
    else
        echo "-1"
    fi
    return 0
}

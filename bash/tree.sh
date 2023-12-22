#!/bin/bash

read n

ROW=63
COLUMN=100
LENGTH=16
STARTING_ROW=63
STARTING_COLUMN=50

declare -A arr

function vertical_line {
        length=$1
        position_row=$2
        position_column=$3
        for i in $(seq 1 $length)
        do
                arr[$position_row,$position_column]='1'
                ((position_row--))
        done
        ((position_column++))
}

function right_cross_line {
        length=$1
        position_row=$2
        position_column=$(bc <<< $3+1)
        recursive_right=$4
        for i in $(seq 1 $length)
        do
                arr[$position_row,$position_column]='1'
                ((position_row--))
                ((position_column++))
        done
        ((position_column--))
        if [ $recursive_right -gt 0 ]
        then
                drawY $(bc <<< $length/2) $position_row $position_column $recursive_right
        fi
        ((position_column--))
}

function left_cross_line {
        length=$1
        position_row=$2
        position_column=$(bc <<< $3-1)
        recursive_left=$4
        for i in $(seq 1 $length)
        do
                arr[$position_row,$position_column]='1'
                ((position_row--))
                ((position_column--))
        done
        ((position_column++))
        if [ $recursive_left -gt 0 ]
        then
                drawY $(bc <<< $length/2) $position_row $position_column $recursive_left
        fi

}

function drawY {
        # length $1
        # position_r $2
        # position_c $3
        # n $4
        vertical_line $1 $2 $3 $4
        right_cross_line $1 $(bc <<< $2-$1) $3 $(bc <<< $4-1)
        left_cross_line $1 $(bc <<< $2-$1) $3 $(bc <<< $4-1)
}

for i in $(seq 1 $ROW)
do
        for j in $(seq 1 $COLUMN)
        do
                arr[$i,$j]='_'
        done
done

drawY $LENGTH $STARTING_ROW $STARTING_COLUMN $n

for i in $(seq 1 $ROW)
do
        for j in $(seq 1 $COLUMN)
        do
                printf "%s" ${arr[$i,$j]}
        done
        echo
done

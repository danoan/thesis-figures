#!/bin/bash

gp_save()
{
	printf "set size 1.0, 0.6;
		set terminal postscript portrait enhanced color dashed lw 1 \"Helvetica\" 20;
		set output \"my-plot.ps\";
		replot;
		set terminal x11;
		set size 1,1;"
}

gp_plot_config()
{    
	printf "set title '$1';
	set xlabel 'Iterations';
	set ylabel 'Elastica ({/Symbol a}=0.01, {/Symbol b}=1)';"
}


gp_add_plot()
{   
	printf "'$1' u 1:2 w l lw 5 title '$2',"

}

gp_last_plot()
{
	printf "'$1' u 1:2 w l lw 5 title '$2';"
}


gp_optimal_line()
{
    printf "set arrow 10 from 0,1.2566 to graph 1, first 1.2566 nohead lw 4 dt 2;"
}


create_multiplot()
{
	fileoutput=$1;shift;
	plottitle=$1;shift;

	buffer="$(gp_plot_config $mode $plottitle)plot "
	i=0
	num_plots=`expr ${#} / 2 - 1`

	while [ ${i} -lt ${num_plots} ]
	do
		subplotDataFile=$1
		subplotTitle=$2
		buffer="${buffer}$(gp_add_plot $mode $subplotDataFile $subplotTitle)"
		shift; shift;

		i=`expr $i + 1`
	done
	
	if [ $num_plots -eq 0 ]
	then
		buffer="${buffer}$(gp_last_plot $mode $1 $2)"
	else	
		buffer="${buffer}$(gp_last_plot $mode $1 $2)"
	fi

	buffer="${buffer}$(gp_optimal_line)$(gp_save)"

	`gnuplot -e "$buffer"`
	`mv my-plot.ps ${fileoutput}`
}



#$1: Output filename
#$2: Graph title
#$4-..: (Plot datafile,Plot subtitle)
#create_multiplot $@

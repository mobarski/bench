module bench

import time
import math

// TODO struct with .mean .stdev .min .max .med ?q1 ?q3
// TODO move into (new) statistics module
fn get_stats(data []i64) (f64,f64,f64,f64) {
	assert data.len>1 // at least 2 data points required
	mut total := i64(0)
	mut min := f64(data[0])
	mut max := f64(data[0])
	for x in data {
		total += x
		if x<min { min = x }
		if x>max { max = x }
	}
	avg := f64(total)/data.len
	mut variance := f64(0) // with Bessel’s correction:
	len := data.len-1      // N-1 degrees of freedom
	for x in data {
		variance += (x-avg)/len * (x-avg)
	}
	stdev := math.sqrt(variance)
	return avg,stdev,min,max
}

fn print_stats(dt_list []i64, n_ops int) {
	//eprintln("$dt_list") // DEBUG
	avg,stdev,min,max := get_stats(dt_list)
	rate := f64(n_ops) / avg
	rate_stdev := stdev * rate / avg
	eprintln("  Time (avg ± stdev): ${avg} µs ± ${stdev} µs")
	eprintln("  Time (min … max):   ${min} µs … ${max} µs")
	if n_ops>0 {
		eprintln("  Rate (avg ± stdev): ${rate} op/µs ± ${rate_stdev} op/µs")
	}
	eprintln("")
}

struct Bench {
mut:
	times []i64
	sw time.StopWatch
}

// new create new object for tracking benchmark statistics
pub fn new(label string) Bench {
	eprint(label)
	mut b := Bench{}
	b.start()
	return b
}

// step register execution step
pub fn (mut b Bench) step() {
	b.times << b.sw.elapsed().microseconds()
	eprint('.')
	b.start()
}

// print prints benchmark statistics
pub fn (b Bench) print(n_ops int) {
	eprintln("")
	print_stats(b.times, n_ops)
}

// start start new stopwatch
fn (mut b Bench) start() {
	b.sw = time.new_stopwatch({})
}

Lean micro-benchmarking framework for the [V language](https://vlang.io).

# Installation

```
v install mobarski.bench
```

# Usage

API consists of only 3 methods:
- `fn new(label string) Bench` - create new benchmark object
- `fn (b Bench) step()` - register execution step
- `fn (b Bench) print(n_ops int)` - print statistics

## Simple example

```v
import mobarski.bench
mut b := bench.new('Simple Benchmark')
for _ in 0..10 {
	... do something ...
	b.step()
}
b.print(0) // 0 -> don't calculate rate
```

Output:
```
Simple Benchmark..........
  Time (avg ± stdev): 12345 µs ± 1000 µs
  Time (min … max):   10000 µs … 20000 µs

```

## Example with rate calculation

```v
import mobarski.bench
n_ops := 1_000_000
n_runs := 20
mut b := bench.new('Rate Calculation Benchmark runs=$n_runs ')
for _ in 0..n_runs {
	for _ in 0..n_ops {
		... do something ...
	}
	b.step()
}
b.print(n_ops)
```

Output:
```
Rate Calculation Benchmark runs=20 ....................
  Time (avg ± stdev): 12345 µs ± 1000 µs
  Time (min … max):   10000 µs … 20000 µs
  Rate (avg ± stdev): 81.0044 op/µs ± 6.5617 op/µs
  
```

## Real life example

```v
import mobarski.bisect
import mobarski.bench

fn bench_first(runs int, size int) {
	// input data
	mut a := []int{len:size}
	for i in 0..size {
		a[i] = i*2
	}
	// benchmark
	mut b := bench.new("bisect.first_available<int> size=$size n_ops=${2*size} runs=$runs ")
	for _ in 0..runs {
		for i in 0..size*2 {
			bisect.first_available<int>(a, i)
		}
		b.step()
	}
	b.print(size*2)
}

bench_first(15, 1_000_000)
bench_first(15, 1_000)
```

Output:
```
bisect.first_available<int> size=1000000 n_ops=2000000 runs=15 ...............
  Time (avg ± stdev): 212594 µs ± 6672.87 µs
  Time (min … max):   205768 µs … 225035 µs
  Rate (avg ± stdev): 9.4076 op/µs ± 0.295284 op/µs

bisect.first_available<int> size=1000 n_ops=2000 runs=15 ...............
  Time (avg ± stdev): 110.733 µs ± 9.32329 µs
  Time (min … max):   107 µs … 144 µs
  Rate (avg ± stdev): 18.0614 op/µs ± 1.5207 op/µs

```

using Test
using BenchmarkTools
using JuliaStudy
using JuliaStudy.JuliaPatterns.StructOfArraysPattern
using StructArrays

PROJECT_ROOT = pkgdir(JuliaStudy)
CURRENT_SRC = "test/JuliaPatterns/ch6/"
SRC_DIR = joinpath(PROJECT_ROOT, CURRENT_SRC)
records = read_trip_payment_file(SRC_DIR *
                                 "yellow_tripdata_2018-12_100k.csv")
fare_amounts = [r.fare_amount for r in records]
columar_records = TripPaymentColumnarData([r.VendorID for r in records],
  [r.tpep_pickup_datetime for r in records],
  [r.tpep_dropoff_datetime for r in records],
  [r.passenger_count for r in records],
  [r.trip_distance for r in records],
  [r.fare_amount for r in records],
  [r.extra for r in records],
  [r.mta_tax for r in records],
  [r.tip_amount for r in records],
  [r.tolls_amount for r in records],
  [r.improvement_surcharge for r in records],
  [r.total_amount for r in records])
sa = StructArray(records)

records2 = read_trip_payment_file2(SRC_DIR *
                                   "yellow_tripdata_2018-12_100k.csv")

@testset "The struct of arrays pattern" begin
  @test mean(r.fare_amount for r in records) ≈ 13.142950
  @btime mean(r.fare_amount for r in records)

  @btime mean(fare_amounts)

  @btime mean(columar_records.fare_amount)

  sa[1:3]
  sa[1]
  typeof(sa[1])
  sa.fare_amount

  @btime mean(sa.fare_amount)

  Base.summarysize(records) / 1024 / 1024
  Base.summarysize(sa) / 1024 / 1024

  # records = nothing
  # GC.gc()

  records2[1]
  sa2 = StructArray(records2)
  sa2[1]
  @test_throws ErrorException sa2.fare.fare_amount
  sa3 = StructArray(records2, unwrap = t -> t <: Fare)
  sa3[1]
  sa3.fare.fare_amount
end

module StructOfArraysPattern

using CSV

export read_trip_payment_file, TripPayment, TripPaymentColumnarData
export read_trip_payment_file2, TripPayment2, Fare

struct TripPayment
  VendorID::Int64
  tpep_pickup_datetime::String
  tpep_dropoff_datetime::String
  passenger_count::Int64
  trip_distance::Float64
  fare_amount::Float64
  extra::Float64
  mta_tax::Float64
  tip_amount::Float64
  tolls_amount::Float64
  improvement_surcharge::Float64
  total_amount::Float64
end

function read_trip_payment_file(file)
  f = CSV.File(file, skipto = 2)
  records = Vector{TripPayment}(undef, length(f))
  for (i, row) in enumerate(f)
    records[i] = TripPayment(row.VendorID, row.tpep_pickup_datetime,
      row.tpep_dropoff_datetime, row.passenger_count, row.trip_distance,
      row.fare_amount, row.extra, row.mta_tax, row.tip_amount,
      row.tolls_amount, row.improvement_surcharge, row.total_amount)
  end
  return records
end

struct TripPaymentColumnarData
  VendorID::Vector{Int64}
  tpep_pickup_datetime::Vector{String}
  tpep_dropoff_datetime::Vector{String}
  passenger_count::Vector{Int64}
  trip_distance::Vector{Float64}
  fare_amount::Vector{Float64}
  extra::Vector{Float64}
  mta_tax::Vector{Float64}
  tip_amount::Vector{Float64}
  tolls_amount::Vector{Float64}
  improvement_surcharge::Vector{Float64}
  total_amount::Vector{Float64}
end

struct Fare
  fare_amount::Float64
  extra::Float64
  mta_tax::Float64
  tip_amount::Float64
  tolls_amount::Float64
  improvement_surcharge::Float64
  total_amount::Float64
end

struct TripPayment2
  VendorID::Int64
  tpep_pickup_datetime::String
  tpep_dropoff_datetime::String
  passenger_count::Int64
  trip_distance::Float64
  fare::Fare
end

function read_trip_payment_file2(file)
  f = CSV.File(file, skipto = 2)
  records = Vector{TripPayment2}(undef, length(f))
  for (i, row) in enumerate(f)
    records[i] = TripPayment2(row.VendorID,
      row.tpep_pickup_datetime,
      row.tpep_dropoff_datetime,
      row.passenger_count,
      row.trip_distance,
      Fare(row.fare_amount,
        row.extra,
        row.mta_tax,
        row.tip_amount,
        row.tolls_amount,
        row.improvement_surcharge,
        row.total_amount))
  end
  return records
end

end

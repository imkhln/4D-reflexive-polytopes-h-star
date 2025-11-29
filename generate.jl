using Oscar

collection = Polymake.Polydb.Collection{Polymake.Polydb.Mongoc.BSON}(Polymake.Polydb.get_db()["Polytopes.Lattice.Reflexive"])
res = Polymake.Polydb.find(collection, Dict(), opts = Dict("projection" => Dict("H_STAR_VECTOR" => true)))

h_star_vecs = Dict{Vector{Int64}, Int64}()
println("polytopes processed:")
for (i, x) in enumerate(res)
    h = x["H_STAR_VECTOR"]
    if haskey(h_star_vecs, h)
        h_star_vecs[h] += 1
    else
        h_star_vecs[h] = 1
    end
    if i % 10^5 == 0
        print(".")
    end
    if i % (5*10^6) == 0
        println(i)
    end
end
println("\n", "h*-vectors found: ", length(keys(h_star_vecs)))

f = open("h_star_vecs", "w")
for h in keys(h_star_vecs)
    write(f, join(string.(h), " "), "\n", string(h_star_vecs[h]), "\n")
end
close(f)
println("\n", "data saved to 'h_star_vecs'")

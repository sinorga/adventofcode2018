#!bin/sh

for f in $(ls *.exs);
do
    echo "Run $f"
    elixir $f
done
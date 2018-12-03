#!bin/sh

cd elixir; mix test; cd -
cd typescript; npm run test; cd -
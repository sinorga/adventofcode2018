defmodule FileUtil do
  defmacro __using__(_args) do
    quote do
      def load_input_raw do
        File.read!("#{File.cwd!()}/../#{@input_file}")
      end
      def load_input do
        load_input_raw()
        |> String.split("\n")
      end

      def load_input_stream do
        File.stream!("#{File.cwd!()}/../#{@input_file}")
      end
    end
  end
end

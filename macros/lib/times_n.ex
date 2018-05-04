defmodule Times do
  # defmodule Temp do
  #   def wow do
  #     IO.puts "cool"
  #   end
  # end

  defmacro n(n) do
    quote do
      def unquote(:"times_#{n}")(num) do
        unquote(n) * num
      end
    end
  end
end

defmodule TimesTest do
  require Times
  Times.n(5)

end

# defmodule Test do
#   require My
#
# end

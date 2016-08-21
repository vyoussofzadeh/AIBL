function overlay_value(m,L)

for i = 1:length(m)
    text(i - 0.2, m(i) + 0.15*m(i), ['N = ', num2str(L(i))], 'VerticalAlignment', 'top', 'FontSize', 8)
end
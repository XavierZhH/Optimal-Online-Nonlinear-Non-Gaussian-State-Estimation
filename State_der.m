function F_k = State_der(state_past, k)


F_k = 1 / 2 + (25 - 50 * state_past^2) / (1 + state_past^2)^2 + 8 * 1.2 * sin(1.2 * k);

end
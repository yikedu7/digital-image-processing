function wie = wiener(H,k)
    wie=H.^(-1).*(abs(H).^2./(abs(H).^2+k));
end
function [zmin,zmax] = get_colormap(image)
zmin = min(image(:));%-0.5;
zmax = max(image(:));%+0.5;
zmin = - max([abs(zmin),abs(zmax)]);
zmax = - zmin;
end
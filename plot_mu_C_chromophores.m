%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_spectra.m
%   plot spectra of all chromophores 
%   input: paras, haxes1, haxes2, haxes3
%         
%   author: jingjing Jiang  jjiang@student.ethz.com
%   created: 01.02.2016
%   modified: 07.03.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_spectra(paras, haxes1, haxes2, haxes3)   
ii = 1;
     T =  650:2:910;
     for wav = T
        [Ex_bulk_HHb(ii) Ex_bulk_OHb(ii) Ex_bulk_H2O(ii) Ex_bulk_Lipid(ii)] = ...
         get_mua_chrom( paras.CHHb,  paras.COHb,  paras.CH2O, paras.CLipid, wav );
        mus_bulk(ii) = paras.a * (wav / 1000)^(-paras.b);
        mua_bulk(ii) = Ex_bulk_HHb(ii) +  Ex_bulk_OHb(ii) + Ex_bulk_H2O(ii) + Ex_bulk_Lipid(ii);
        [Ex_vessel_HHb(ii) Ex_vessel_OHb(ii) t t] = ...
         get_mua_chrom( 0.4*(1- paras.StOv),  0.4*(paras.StOv),  0.4, 0.4, wav );  
     % 0.4 is an arbitrary value for the concentration of Hb for the vessel
         mu_eff(ii) = sqrt(3*mua_bulk(ii)*mus_bulk(ii));
         ii = ii + 1;
     end

     axes(haxes1)
     cla
     [hAx,hLine1,hLine2] = plotyy([T'],...
     [Ex_bulk_HHb', Ex_bulk_OHb', Ex_bulk_H2O',Ex_bulk_Lipid', mua_bulk'],T,mu_eff);
     legend('\mu_a^{Hb}', '\mu_a^{OHb}', '\mu_a^{H2O}'  ,'\mu_a^{Lipid}','\mu_a', '\mu_{eff}')
     set(hLine2, 'LineStyle','--')
     set(hLine2,'LineWidth',3)
     title('Coefficients for the bulk')
     xlabel('wavelength [nm]')
     ylabel('coefficient [mm^{-1}]')
        
     axes(haxes2)
     plot(T,mus_bulk)
     title('Scattering Coefficients for the bulk')
     xlabel('wavelength [nm]')
     ylabel('coefficient [mm^{-1}]')
     
     axes(haxes3)
     cla
     [hAx,hLine1,hLine2] = plotyy([T'],...
            [Ex_vessel_HHb', Ex_vessel_OHb'],T,Ex_vessel_HHb+Ex_vessel_OHb);
     set(hLine2, 'LineStyle','--')
     set(hLine2,'LineWidth',3)
     legend('HHb', 'OHb','\mua')
     title('Extinction coefficients for the vessel')
     xlabel('wavelength [nm]')
     ylabel('coefficient [mm^{-1}]')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_mua_chrom.m
% 
% output: [Ex_Hb Ex_HbO Ex_H2O Ex_lipid]
% input: c_HHb, c_OHb, c_H2O, c_lipid
%        wav: wavelength
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ex_Hb Ex_HbO Ex_H2O Ex_lipid] = get_mua_chrom(c_HHb, c_OHb, c_H2O,c_lipid,  wav )

TABLE_NIRFAST
T = 650:1:910;
Ex_Hb = c_HHb * table_coeff(find(T== floor(wav)),2); %[1/(mM*mm)]
Ex_HbO = c_OHb * table_coeff(find(T== floor(wav)),1);
Ex_H2O = c_H2O * table_coeff(find(T== floor(wav)),3);
Ex_lipid =c_lipid *  table_coeff(find(T== floor(wav)),4);
end

 
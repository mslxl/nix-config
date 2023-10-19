{
    pkgs,
    ...
}:{
    home.packages = with pkgs; [
        zathura
        zathuraPkgs.zathura_pdf_mupdf
        zathuraPkgs.zathura_cb
    ];
}
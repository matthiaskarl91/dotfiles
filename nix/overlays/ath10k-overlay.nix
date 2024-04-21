/*(self: super: */

/*let
  ath10kWithPatch = super.linuxPackages_latest.ath10k.override {
    patches = [
      ./402-ath_regd_optional.patch
      ./403-world_regd_fixup.patch
    ];
  };
in*/
(self: super: {
  linuxPackages_latest = super.linuxPackages_latest.extend(lpself: lpsuper: {
    ath10k = super.linuxPackages_latest.ath10k.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        ./402-ath_regd_optional.patch
        ./403-world_regd_fixup.patch
      ];
    });
  });
})

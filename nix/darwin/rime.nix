{
  rime-ice,
  lib,
  ...
}: let
  rimeConfigDir = "Library/Rime";
in {
  # ${rimeConfigDir} is the default config dir of Squirrel
  home.file."${rimeConfigDir}" = {
    source = rime-ice;
    recursive = true;
    force = true;
  };

  # patches
  home.file."${rimeConfigDir}/default.custom.yaml" = {
    text = ''
      patch:
        version: "1.0"
        schema_list:
          - schema: double_pinyin_flypy
        menu:
          page_size: 7
        switcher/hotkeys/=:
        ascii_composer/switch_key/Shift_L: noop
        ascii_composer/good_old_caps_lock: false
        punctuator/digit_separators: ""
        key_binder/select_last_character: ""
        key_binder/select_first_character: ""
        key_binder/bindings:
          - { when: paging, accept: bracketleft, send: Page_Up }
          - { when: has_menu, accept: bracketright, send: Page_Down }
    '';
    force = true;
  };

  home.file."${rimeConfigDir}/double_pinyin_flypy.custom.yaml" = {
    text = ''
      patch:
        version: "1.0"
        translator/preedit_format/=:
          - xform/(?<=[A-Z])\s(?=[A-Z])//  # remove the spaces between upper chars
        melt_eng/enable_user_dict: true
        key_binder/search: ";"
        speller/alphabet: zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA;

        engine/processors/@1:
        punctuator/digit_separators: ""
    '';
    force = true;
  };

  home.file."${rimeConfigDir}/radical_pinyin.custom.yaml" = {
    text = ''
      patch:
        speller/algebra:
            __include: radical_pinyin.schema.yaml:/algebra_flypy
    '';
    force = true;
  };

  home.file."${rimeConfigDir}/rime_ice.custom.yaml" = {
    text = ''
      patch:
        speller/algebra:
            __include: radical_pinyin.schema.yaml:/algebra_flypy
    '';
    force = true;
  };

  home.file."${rimeConfigDir}/squirrel.custom.yaml" = {
    text = ''
      patch:
        style/color_scheme: native
        style/color_scheme_dark: native
        style/candidate_list_layout: linear  # stacked | linear
        style/font_face: "PingFang SC"
    '';
    force = true;
  };

  # restart Squirrel
  home.activation.restartSquirrel = lib.hm.dag.entryAfter ["writeBoundary"] ''
    /Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
  '';
}

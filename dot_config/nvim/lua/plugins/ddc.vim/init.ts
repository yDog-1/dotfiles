import {
  BaseConfig,
  type ConfigArguments,
} from "jsr:@shougo/ddc-vim@10.1.0/config";

export class Config extends BaseConfig {
  // deno-lint-ignore require-await
  override async config(args: ConfigArguments) {
    args.contextBuilder.setGlobal({
      ui: "pum",
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "TextChangedT",
      ],
      sources: [
        "lsp",
        "skkeleton",
        "skkeleton_okuri",
        "around",
      ],
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_fuzzy"],
          converters: ["converter_fuzzy"],
        },
        lsp: {
          mark: "L",
          forceCompletionPattern: String.raw`\.\w*|::\w*|->\w*`,
          isVolatile: true,
        },
        around: {
          mark: "A",
        },
        skkeleton: {
          mark: "SKK",
          matchers: [],
          sorters: [],
          converters: [],
          isVolatile: true,
          minAutoCompleteLength: 1,
        },
        skkeleton_okuri: {
          mark: "SKK*",
          matchers: [],
          sorters: [],
          converters: [],
          isVolatile: true,
        },
      },
      sourceParams: {
        lsp: {
          enableResolveItem: true,
          enableAdditionalTextEdit: true,
        },
      },
    });
  }
}

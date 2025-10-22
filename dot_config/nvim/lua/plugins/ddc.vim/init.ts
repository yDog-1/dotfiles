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
          mark: "LSP",
          forceCompletionPattern: String.raw`\.\w*|::\w*|->\w*`,
          isVolatile: true,
          sorters: ["sorter_rank", "sorter_fuzzy", "sorter_lsp_kind"],
          converters: ["converter_fuzzy", "converter_kind_labels"],
          maxItems: 20
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
        converter_kind_labels: {
          kindLabels: {
            Text: " ",
            Method: " ",
            Function: " ",
            Constructor: " ",
            Field: " ",
            Variable: " ",
            Class: " ",
            Interface: " ",
            Module: " ",
            Property: " ",
            Unit: " ",
            Value: " ",
            Enum: " ",
            Keyword: " ",
            Snippet: " ",
            Color: " ",
            File: " ",
            Reference: " ",
            Folder: " ",
            EnumMember: " ",
            Constant: " ",
            Struct: " ",
            Event: " ",
            Operator: " ",
            TypeParameter: " ",
          },
          kindHlGroups: {
            Method: "Function",
            Function: "Function",
            Constructor: "Function",
            Field: "Identifier",
            Variable: "Identifier",
            Class: "Structure",
            Interface: "Structure",
          },
        },
      },
    });
  }
}

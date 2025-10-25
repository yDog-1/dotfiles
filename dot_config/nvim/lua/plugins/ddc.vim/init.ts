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
        "file",
        "lsp",
        "skkeleton",
        "skkeleton_okuri",
        "buffer",
        "around",
      ],
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fuzzy", "matcher_length"],
          sorters: ["sorter_rank", "sorter_fuzzy"],
          converters: ["converter_fuzzy"],
        },
        lsp: {
          mark: "LSP",
          forceCompletionPattern: String.raw`\.\w*|::\w*|->\w*`,
          isVolatile: true,
          sorters: ["sorter_rank", "sorter_fuzzy", "sorter_lsp_kind"],
          converters: ["converter_fuzzy", "converter_kind_labels"],
          maxItems: 20,
        },
        file: {
          isVolatile: true,
          minAutoCompleteLength: 1000,
          forceCompletionPattern: String.raw`\S/\S*`,
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
        buffer: {
          requireSameFiletype: false,
        },
        lsp: {
          enableResolveItem: true,
          enableAdditionalTextEdit: true,
        },
        file: {
          displayFile: " ",
          displayDir: " ",
          displaySym: "sym",
          displaySymFile: "sym ",
          displaySymDir: "sym ",
        },
      },
      filterParams: {
        matcher_fuzzy: {
          splitMode: "word",
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
